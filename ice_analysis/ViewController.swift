//
//  ViewController.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/28.
//

import UIKit

let reuseIdentifier = "CECell";

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var outerResLabel: UILabel!
    @IBOutlet weak var changeCharactorbtn: UIButton!
    @IBOutlet weak var charactorLabel: UILabel!
    
    let nameOrdered = ["flower","feather","sand","cup","hat"]
    let subVerb = ["暴击率","暴击伤害","大攻击","小攻击","元素精通","元素充能","大生命","小生命","大防御","小防御","治疗量","元素伤害"]
    let charactorNames = ["神里绫华","八重神子","刻晴","雷电将军","班尼特","枫原万叶","珊瑚宫心海","菲谢尔","甘雨","烟绯","迪卢克","罗莎莉亚","迪奥娜","莫娜","爷","七七","鹿野苑平藏","九条裟罗","钟离","胡桃","草神"]
    let subVerbMaxVals = [31.1,62.2,46.6,311,187,51.8,4780,4780,58.6,58.6,35.9,46.6]
    let midPerCount = [3.3,6.6,5.0,50,20,5.5,5.0,600,6.2,43,100,100]
    
    public var mainContents:Array<String>!
    public var mainVals:Array<Double>!
    public var subContents:Array< Array<String>>!
    public var subVals:Array<Array<Double>>!
    public var currentName:String = "auto";
    var lastRecev : Int = 0;
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! IceCollectionCell
        print(indexPath.row)
        cell.setImage(img: UIImage(imageLiteralResourceName: nameOrdered[indexPath.row]), ider: indexPath.row, mC: mainContents[indexPath.row],mV: mainVals[indexPath.row],sC: subContents[indexPath.row],sV: subVals[indexPath.row])
        cell.backgroundColor = self.randomColor()

        return cell
    }
    
    func saveToDefaultsKey(K:String){
        let defaults = UserDefaults.standard
        let mainContentsK = K + "?mainContents"
        let mainValsK = K + "?mainVals"
        let subContentsK = K + "?subContents"
        let subValsK = K + "?subVals"
        defaults.set(self.mainContents, forKey: mainContentsK)
        defaults.set(self.mainVals, forKey: mainValsK)
        defaults.set(self.subContents, forKey: subContentsK)
        defaults.set(self.subVals, forKey: subValsK)
        self.charactorLabel.text = currentName
    }
    
    func readLastName() -> String {
        let defaults = UserDefaults.standard
        let lastName = defaults.object(forKey: "ICELASTNAME@");
        if(lastName == nil){
            return "auto"
        }
        
        return lastName as! String
    }
    func updateLastName(Name:String){
        let defaults = UserDefaults.standard
        self.swicthCurrentName(Name: Name)
        defaults.set(Name, forKey: "ICELASTNAME@")
        if(readDefaultsKey(K: Name)){
            self.collectionView.reloadData()
            self.startAnalysis(self.changeCharactorbtn as Any)
        }
    }
    
    func swicthCurrentName(Name:String){
        self.currentName = Name
        self.charactorLabel.text = self.currentName
    }
    
    func readDefaultsKey(K:String) -> Bool{
        let defaults = UserDefaults.standard
        let mainContentsK = K + "?mainContents"
        let mainValsK = K + "?mainVals"
        let subContentsK = K + "?subContents"
        let subValsK = K + "?subVals"
        
        let item = defaults.object(forKey: mainContentsK)
        if(item == nil){
            return false;
        }
        
        self.mainContents = defaults.object(forKey: mainContentsK) as? Array<String>
        self.mainVals = defaults.object(forKey: mainValsK) as? Array<Double>
        self.subContents = defaults.object(forKey: subContentsK) as? Array<Array<String>>
        self.subVals = defaults.object(forKey: subValsK) as? Array<Array<Double>>
        return true;
    }
    
    /// 监听通知
    private func registerNoti() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(receive(noti:)), name: NSNotification.Name("viewNotiSecond"), object: nil)
    }
    

    @objc func receive(noti : NSNotification){
        print("recev some noti")
        let item = noti.userInfo
        let bodyi = item?["body"]
        lastRecev = bodyi as! Int
        if(lastRecev < 100){
            let rm = lastRecev % 10;
            if(rm < 5 || rm == 9){
                self.showAlert(value: "更改为");
            }
        } else {
            let remainId = lastRecev % 100;
            let filteredVal = lastRecev - remainId;
            lastRecev = remainId;
            let blockId = remainId / 10;
            let innerId = remainId - blockId * 10 - 5;
            let trVal = Double(filteredVal) / 10000;
            subVals[blockId][innerId] = trVal;
            self.saveNow()
        }
    }
    
    func saveNow(){
        self.saveToDefaultsKey(K: currentName)
    }
    
    func showCharactorPickWin(){
        let alertView = UIAlertController(title: "选择角色", message: "", preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        
        for i in 0 ..< charactorNames.endIndex {
            alertView.addAction(UIAlertAction(title: charactorNames[i], style: .default) { [self] _ in
                print("Pick ",self.charactorNames[i])
                self.updateLastName(Name: self.charactorNames[i]);
            })
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func changeCharactor(_ sender: Any) {
        showCharactorPickWin()
    }
    
    @IBAction func startAnalysis(_ sender: Any) {
        outerResLabel.text = "评估中";
        var outkeys = ["暴击","暴伤","攻击","充能","精通", "生命","防御"]
        var res : Dictionary<String, Double>;
        res = Dictionary<String,Double>()
        for k in outkeys {
            res[k] = 0.0
        }
        for i in 0 ... 4 {
            var score = 0.0
            for j in 0 ... 3{
                var wh = 0;
                for p in 0 ... 9 {
                    if(subVerb[p] == subContents[i][j]){
                        wh = p;
                        break;
                    }
                }
                let counter = subVals[i][j] / midPerCount[wh];
                switch(wh){
                case 0 :
                    res["暴击"]!+=counter;
                    break
                case 1 :
                    res["暴伤"]!+=counter;
                    break
                    
                case 2 :
                    fallthrough
                case 3 :
                    res["攻击"]!+=counter;
                    break
                    
                case 4 :
                    res["精通"]!+=counter;
                    break
                    
                case 5 :
                    res["充能"]!+=counter;
                    break
                    
                case 6 :
                    fallthrough
                case 7 :
                    res["生命"]!+=counter;
                    break
                
                case 8 :
                    fallthrough
                case 9 :
                    res["防御"]!+=counter;
                    break
                
                default:
                    break
                }
            }
        }
        var fin = "";
        var counter = 0
        var validCount = 0.0
        for k in outkeys {
            fin += k + " " + String(format: "%1.1f", res[k]!)
            counter += 1
            if(counter <= 3){
                validCount += res[k]!
            }
            if counter % 2 == 0 {
                fin += "\n"
            } else {
                fin += "    "
            }
        }
        fin += String(format: "攻暴 %1.1f", validCount)
        outerResLabel.text = fin
    }
    
    func showAlert(value : String){
        let alertView = UIAlertController(title: "副词修改", message: value, preferredStyle: .actionSheet)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        
        for i in 0 ..< subVerb.endIndex {
            alertView.addAction(UIAlertAction(title: subVerb[i], style: .default) { [self] _ in
                print("Pick ",self.subVerb[i])
                let blockId = Int(self.lastRecev / 10);
                let subId = self.lastRecev % 10;
                if(subId == 9) {
                    self.mainContents[blockId] = self.subVerb[i];
                    self.mainVals[blockId] = self.subVerbMaxVals[i];
                } else {
                    self.subContents[blockId][subId] = self.subVerb[i];
                }
                self.saveNow()
                self.collectionView.reloadData();
            })
        }
        self.present(alertView, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lastName = self.readLastName()
        swicthCurrentName(Name: lastName)
        
        if(!self.readDefaultsKey(K: currentName)){
            self.mainVals = Array(repeating: 0.0, count: 5);
            self.mainContents = Array(repeating: "生命值", count: 5);
            self.subVals = Array(repeating: Array(repeating: 0.0, count: 4), count: 5);
            self.subContents = Array(repeating: Array(repeating: "大攻击", count: 4), count: 5);
        }

        
        self.collectionView.register(IceCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        registerNoti();

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NotificationCenter.default.removeObserver(self)
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 4;
    }
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1;
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 0.05)
    }

}

