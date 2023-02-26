//
//  ViewController.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/28.
//

import UIKit
import CloudKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!

    //各个属性权重
    var validVals:Array<Double>!
    var outkeysToId:Dictionary<String,Int>!
    
    let subVerb = ["暴击率","暴击伤害","大攻击","小攻击","元素精通","元素充能","大生命","小生命","大防御","小防御","治疗量","元素伤害","物理伤害","生命值", "破防", "减抗","充能转增伤","额外反应"," "]
    let charactorNames = ["神里绫华","八重神子","刻晴","雷电将军","班尼特","枫原万叶","珊瑚宫心海","菲谢尔","甘雨","胡桃","草神","夜兰","烟绯","迪卢克","罗莎莉亚","迪奥娜","莫娜","爷","七七","鹿野苑平藏","九条裟罗","钟离"]
    
    let weaponNames = ["雾切","磐岩结绿", "四风原典","破魔之弓","阿莫斯之弓","西风猎弓","猎人之径","渔获","不灭月华","天空之刃", "护摩","绝弦","若水","铁蜂刺","匣里龙吟","天目影打刀","贯虹之槊","和璞鸢","薙草之稻光","试作斩岩","落霞"]
    
    let subVerbMaxVals = [31.1,62.2,46.65,311,187,51.8,46.6,4780,58.6,58.6,35.9,46.6,58.6, 4780]
    let midPerCount = [3.305,6.61,4.9575,50,20,5.5,5.0,600,6.2,43,100,100,100, 600]
    var subVerbToIdDict = Dictionary<String,Int>()
    let unitPerCount = [0.389,0.777,0.583,1.945,2.331,0.648,0.583,29.875,0.729,2.315,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0]
    // 9.409984871406959
    private var mainContents:Array<String>!
    private var mainVals:Array<Double>!
    private var subContents:Array< Array<String>>!
    private var subVals:Array<Array<Double>>!
    private var currentName:String = "神里绫华";
    private var currentWeapon:String = "雾切"
    
    private var extraContents:Array<String>!
    private var extraVals:Array<Double>!
    
    var lastRecev : Int = 0;
    
    var keyAnalysisResult :String = ""
    var currentPadData:Array<Double>!
     
    func initSubVerbToIdDict() {
        for i in 0 ..< subVerb.count {
            subVerbToIdDict[subVerb[i]] = i
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row < 5){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! IceCollectionCell
            print(indexPath.row)
            cell.setImage(img: UIImage(imageLiteralResourceName: nameOrdered[indexPath.row]), ider: indexPath.row, mC: mainContents[indexPath.row],mV: mainVals[indexPath.row],sC: subContents[indexPath.row],sV: subVals[indexPath.row],estimate: self.scoreEstimate(ider: indexPath.row), validKeys: self.packValidKeys())
            cell.backgroundColor = self.randomColor()
            cell.layer.cornerRadius = 10.0
            return cell
        } else if(indexPath.row == 5){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusePickerIdentifier, for: indexPath as IndexPath) as! ValidPickerCell
            print(indexPath.row)
            var totalScoreNow = 0.0
            for i in 0 ... 4 {
                totalScoreNow += self.scoreEstimate(ider: i)
            }
            let detail = self.startAnalysis()
            cell.flushPickColor(validVals: self.validVals, totalscore: totalScoreNow, detailCounts: detail)
            cell.backgroundColor = self.randomColor()
            
            return cell
        } else if(indexPath.row == 6){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCharactorIdentifier, for: indexPath as IndexPath) as! CharactorWeaponCell
            print(indexPath.row)
            cell.chooseCharactorWeapon(charactor: currentName, weapon: currentWeapon)
            cell.displayKeyDamage(Content: keyAnalysisResult)
            cell.backgroundColor = self.randomColor()
            return cell
        } else if(indexPath.row == 7) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCurrentPadIdentifier, for: indexPath as IndexPath) as! CurrentPadStatusCell
            print(indexPath.row)
            cell.loadPadDatas(validVals: currentPadData)
            cell.backgroundColor = self.randomColor()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! IceCollectionCell
            print(indexPath.row)
            
            cell.setImage(img: UIImage(imageLiteralResourceName: indexPath.row == 8 ? "star" : "good"), ider: indexPath.row, mC: "",mV: 0,sC: extraContents,sV: extraVals,estimate: 0, validKeys: self.packValidKeys())
            cell.backgroundColor = self.randomColor()
            cell.layer.cornerRadius = 10.0
            return cell
        }
        
    }
    
    func convertToAttrDict(i : Int) -> Dictionary<String,Double> {
        var res = Dictionary<String,Double>()
        for k in outkeys {
            res[k] = 0.0
        }
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
        return res
    }
    
    func scoreEstimate(ider : Int) -> Double {
        var finresval = 0.0
        let res = self.convertToAttrDict(i: ider)
        for tup in res {
            let rid = self.outkeysToId[tup.key]
            if(validVals[rid!] > 0){
                finresval += validVals[rid!] * tup.value
            }
        }
        finresval *= 6.6
        return finresval
    }
    
    func packValidKeys() -> Array<String> {
        var res = Array<String>();
        for k in outkeys {
            let ider = outkeysToId[k];
            if(validVals[ider!] > 0){
                res.append(k)
            }
        }
        return res
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
        }
    }
    
    func updateLastWeapon(Name:String){
        self.currentWeapon = Name
        keyAnalysisResult = howMuchDamage()
        self.collectionView.reloadData()
    }
    
    
    func swicthCurrentName(Name:String){
        self.currentName = Name
    }
    
    func saveToDefaultsKey(K:String){
        let defaults = UserDefaults.standard
        let mainContentsK = K + "?mainContents"
        let mainValsK = K + "?mainVals"
        let subContentsK = K + "?subContents"
        let subValsK = K + "?subVals"
        let validValsK = K + "?validVals"
        let weaponK = K + "?weapon"
        let extraContentsK = K + "?extraContents"
        let extraValsK = K + "?extraVals"
        
        defaults.set(self.mainContents, forKey: mainContentsK)
        defaults.set(self.mainVals, forKey: mainValsK)
        defaults.set(self.subContents, forKey: subContentsK)
        defaults.set(self.subVals, forKey: subValsK)
        defaults.set(self.validVals, forKey: validValsK)
        defaults.set(self.currentWeapon, forKey: weaponK)
        defaults.set(self.extraContents, forKey: extraContentsK)
        defaults.set(self.extraVals, forKey: extraValsK)
    }
    
    func helpValidSave(K:String){
        let defaults = UserDefaults.standard
        let validValsK = K + "?validVals"
        let item = defaults.object(forKey: validValsK)
        if(item == nil){
            defaults.set(self.validVals, forKey: validValsK)
        }
    }
    
    func testDefaultsKeyExist(K:String) -> Bool {
        let mainContentsK = K + "?mainContents"
        let item = UserDefaults.standard.object(forKey: mainContentsK)
        if(item == nil){
            return false;
        }
        return true
    }
    
    func readDefaultsKey(K:String) -> Bool{
        let defaults = UserDefaults.standard
        let mainContentsK = K + "?mainContents"
        
        let item = defaults.object(forKey: mainContentsK)
        if(item == nil){
            return false;
        }
        
        let mainValsK = K + "?mainVals"
        let subContentsK = K + "?subContents"
        let subValsK = K + "?subVals"
        let validValsK = K + "?validVals"
        let weaponK = K + "?weapon"
        let extraContentsK = K + "?extraContents"
        let extraValsK = K + "?extraVals"
        
        self.mainContents = (defaults.object(forKey: mainContentsK) as! Array<String>)
        self.mainVals = (defaults.object(forKey: mainValsK) as! Array<Double>)
        self.subContents = (defaults.object(forKey: subContentsK) as! Array<Array<String>>)
        self.subVals = (defaults.object(forKey: subValsK) as! Array<Array<Double>>)
        self.validVals = (defaults.object(forKey: validValsK) as! Array<Double>)
        self.currentWeapon = defaults.object(forKey: weaponK) as! String
        self.extraContents = (defaults.object(forKey: extraContentsK) as! Array<String>)
        self.extraVals = (defaults.object(forKey: extraValsK) as! Array<Double>)
        
        keyAnalysisResult = howMuchDamage()
        self.collectionView.reloadData()
        
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
        } else if(lastRecev >= 1000 && lastRecev < 1010){
            let toggleid = lastRecev - 1000;
            validVals[toggleid] *= -1;
            self.collectionView.reloadData()
        } else if(lastRecev >= 2000 && lastRecev < 2100){
            if(lastRecev == 2000){
                showCharactorPickWin()
            }
            if(lastRecev == 2001){
                showWeaponPickWin()
//                keyAnalysisResult = howMuchDamage()
//                self.collectionView.reloadData()
            }
            if(lastRecev == 2002){
                keyAnalysisResult = howMuchDamage()
                self.collectionView.reloadData()
            }
            
            if(lastRecev == 2005){
                self.readingFromWin(saveKey: "")
            }
            
            if(lastRecev == 2006){
                self.savingToWin(saveKey: "")
            }

        } else if(lastRecev > 10000) {
            let remainId = lastRecev % 100;
            let filteredVal = lastRecev - remainId;
            lastRecev = remainId;
            let blockId = remainId / 10;
            var innerId = remainId - blockId * 10 - 5;
            let trVal = Double(filteredVal) / 10000;
            if(blockId < 5){
                subVals[blockId][innerId] = trVal;
            } else {
                if(blockId > 8){
                    innerId += 4
                }
                extraVals[innerId] = trVal;
                print("recev extra val at ",innerId)
                print(trVal)
            }

        }
        
        self.saveNow()
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
    
    func showWeaponPickWin(){
        let alertView = UIAlertController(title: "选择武器", message: "", preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        
        for i in 0 ..< weaponNames.endIndex {
            alertView.addAction(UIAlertAction(title: weaponNames[i], style: .default) { [self] _ in
                print("Pick ",self.weaponNames[i])
                self.updateLastWeapon(Name: self.weaponNames[i]);
            })
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    func startAnalysis() -> Dictionary<String,Double> {
        var res : Dictionary<String, Double>;
        res = Dictionary<String,Double>()
        for k in outkeys {
            res[k] = 0.0
        }
        for i in 0 ... 4 {
            let tempDict = self.convertToAttrDict(i: i);
            for item in tempDict {
                res[item.key]! += item.value
            }
        }
        return res
    }
    
    func normalizeSubVal(name : String, orgVal : Double) -> Double {
        if let id = subVerbToIdDict[name] {
            print("fixing ",name, orgVal)
            let unit = unitPerCount[id]
            var rate = orgVal / unit
            var rounded = round(rate)
            var fixedVal = rounded * unit
            print("fixed is ",fixedVal)
            return fixedVal
        } else {
            return orgVal
        }

    }
    
    func packingAllToOneDict() -> Dictionary<String,String> {
        var finres = Dictionary<String,String>()
        var res = Dictionary<String,Double>()
        for k in subVerb {
            res[k] = 0.0
        }
        for i in 0 ... 4 {
            let maxval = mainVals[i]
            let maxkey = mainContents[i]
            res[maxkey]! += maxval
            for j in 0 ... 3 {
                res[subContents[i][j]]! += normalizeSubVal(name: subContents[i][j], orgVal: subVals[i][j]) 
            }
        }
        
        for i in 0 ... 9 {
            if subVerb.contains(extraContents[i]) {
                res[extraContents[i]]! += extraVals[i]
                print("PKing")
                print(extraContents[i])
                print(extraVals[i])
            }
        }

        for item in res {
            let strVal = String(format:"%f",Double(item.value) )
            finres[item.key] = strVal
        }
        print(finres)
        return finres
    }
    
    func howMuchDamage() -> String {
        let rcDict = packingAllToOneDict()
        print(rcDict)
        let cc = CharactorBase()
        var res = ""
        
        let loadName = self.currentName
        let loadWeapon = self.currentWeapon
        
        cc.loadCharactorName(Name: loadName)
        cc.loadWeaponName(Name: loadWeapon)
        cc.loadCurrentRelic(cDict: rcDict)
        res = DamageCore.getCharactorKeyResultFromBase(base: cc, charactorName: loadName)
    
        self.currentPadData = cc.printCurrentPad()
        return res
    }
    @IBAction func changeCharactor(_ sender: Any) {
        showCharactorPickWin()
    }
    
    func getCopyK(index : Int) -> String {
        let k = String(format: "%@Copy$%d$", currentName ,index)
        return k
    }
    func getSlotTotalCount() -> Int {
        return 100
    }
    func readingFromWin(saveKey : String){
        
        let titmessage = String(format: "从哪个副本读取[%@]", currentName)
        let helpmessage = String(format: "如果不存在副本会将当前内容保存至该副本")
        let alertView = UIAlertController(title: titmessage, message: helpmessage, preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        
        for i in 0 ..< getSlotTotalCount() {
            var tit = String(format: "读取副本 %d", i)
            let k = getCopyK(index: i)
            if !testDefaultsKeyExist(K: k) {
                tit += " [空]"
            }
            alertView.addAction(UIAlertAction(title: tit, style: .default) { [self] _ in
                print("Read Pick ",i)
                let pickedKey = getCopyK(index: i)
                if testDefaultsKeyExist(K: pickedKey) {
                    if !readDefaultsKey(K: pickedKey) {
                        saveToDefaultsKey(K: pickedKey)
                    }
                } else {
                    saveToDefaultsKey(K: pickedKey)
                }
            })
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    func savingToWin(saveKey : String){
        let alertView = UIAlertController(title: "覆盖保存到哪个副本?", message: currentName, preferredStyle: .actionSheet)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        
        for i in 0 ..< getSlotTotalCount() {
            var tit = String(format: "保存到副本 %d", i)
            let k = getCopyK(index: i)
            if !testDefaultsKeyExist(K: k) {
                tit += " [空]"
            }
            alertView.addAction(UIAlertAction(title: tit, style: .default) { [self] _ in
                print("Save Pick ",i)
                let pickedKey = getCopyK(index: i)
                saveToDefaultsKey(K: pickedKey)
            })
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlert(value : String){
        let alertView = UIAlertController(title: "副词修改", message: value, preferredStyle: .actionSheet)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
        })
        
        for i in 0 ..< subVerb.endIndex {
            alertView.addAction(UIAlertAction(title: subVerb[i], style: .default) { [self] _ in
                print("Pick ",self.subVerb[i])
                let blockId = Int(self.lastRecev / 10);
                var subId = self.lastRecev % 10;
                
                if(blockId < 5){
                    if(subId == 9) {
                        self.mainContents[blockId] = self.subVerb[i];
                        self.mainVals[blockId] = self.subVerbMaxVals[i];
                    } else {
                        self.subContents[blockId][subId] = self.subVerb[i];
                    }
                } else {
                    if(blockId > 8){
                        subId += 4
                    }
                    self.extraContents[subId] = self.subVerb[i];
                }
                

                self.saveNow()
                self.collectionView.reloadData();
            })
        }
        self.present(alertView, animated: true, completion: nil)
    }
    
    @objc func tappedColorBtn(_ button:UIButton){
        print(button.tag)
        var toggleId = button.tag - 1000
        validVals[toggleId] *= -1
        if(validVals[toggleId] < 0){
            button.backgroundColor = UIColor (named: "lightred")
        } else {
            button.backgroundColor = UIColor (named: "lightgreen")
        }
        self.collectionView.reloadData()
    }
    
    func setupUI(){
        if(self.validVals == nil){
            validVals = Array<Double>(repeating: 1.0, count: 9)
        }

        self.outkeysToId = Dictionary<String,Int>()
        for i in 0 ..< outkeys.endIndex {
            self.outkeysToId[outkeys[i]] = i
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubVerbToIdDict()
        var lastName = self.readLastName()
        self.currentPadData = Array(repeating: 0.0, count: 8)
        print(lastName)
        if(lastName != "auto"){
            swicthCurrentName(Name: lastName)
        }

        
        if(!self.readDefaultsKey(K: currentName)){
            self.mainVals = Array(repeating: 0.0, count: 5);
            self.mainContents = Array(repeating: "生命值", count: 5);
            self.subVals = Array(repeating: Array(repeating: 0.0, count: 4), count: 5);
            self.subContents = Array(repeating: Array(repeating: "大攻击", count: 4), count: 5);
            self.extraVals = Array(repeating: 0.0, count: 10)
            self.extraContents = Array(repeating: " ", count: 10)
        }

        setupUI()
        for nam in charactorNames {
            self.helpValidSave(K: nam)
        }
        self.collectionView.register(IceCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(ValidPickerCell.self, forCellWithReuseIdentifier: reusePickerIdentifier)
        self.collectionView.register(CharactorWeaponCell.self, forCellWithReuseIdentifier: reuseCharactorIdentifier)
        self.collectionView.register(CurrentPadStatusCell.self, forCellWithReuseIdentifier: reuseCurrentPadIdentifier)
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        debugPrint("will disappear inregister ")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            debugPrint("will appear register ")
            self.registerNoti();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 6;
    }
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let smallone = ScreenUtils.getScreenSmallSideLength()
        let real = smallone / 2.0 - 3
        return CGSize(width: real, height: real)
    }
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 0.05)
    }

}

