//
//  IceCollectionCell.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/28.
//

import Foundation
import UIKit

class IceCollectionCell : UICollectionViewCell {
    var imageView:UIImageView!
    var mainContent:UIButton!
    public var subContents:Array<UIButton>!
    public var subVals:Array<UITextField>!
    var scoreLabel:UILabel!
    var BaseId:Int = 0;
    var lastRecev:Int = 0;
    var firstInit:Int = 1;

    override init(frame:CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    

    
    @objc func tapped(_ button:UIButton){
        print(button.tag)
        postNoti(btn: button.tag)
    }

    @objc func valueChange(_ field:UITextField){
        if(field.text == ""){
            field.text = "0"
        }
        var dVal = Double(field.text!)!
        var biggerWrap = Int(dVal * 10000);
        biggerWrap += field.tag
        print(biggerWrap)
        postNoti(btn: biggerWrap)
    }
    
    @objc func valueClear(_ field:UITextField){
        field.text = ""
    }

    
    func setupUI(){
        print("set up UI")
        self.imageView = UIImageView()
        self.mainContent = UIButton()
        self.scoreLabel = UILabel()
        
        subContents = Array<UIButton>();
        subVals = Array<UITextField>();
        
        let smallsidelen = ScreenUtils.getScreenSmallSideLength()
        let cellper = smallsidelen * 0.08
        // 25 = cellper in 12mini scale mode
        
        self.imageView.frame = CGRect(x: cellper * 0.08, y: cellper * 0.8, width: cellper, height: cellper);
        self.imageView.layer.cornerRadius = 10.0
        
        self.mainContent.frame = CGRect(x:cellper * 1.08, y: cellper * 0.8, width: cellper * 5, height: cellper);
        self.mainContent.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        self.mainContent.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.mainContent.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        self.mainContent.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
        
        self.scoreLabel.frame = CGRect(x: cellper * 4.4, y: 0.0, width: cellper * 1.52, height: 0.6 * cellper);
        self.scoreLabel.textColor =  UIColor(red: 0.972, green: 0.863, blue: 0.565, alpha: 1.0)
        self.scoreLabel.backgroundColor = UIColor(red: 0.472, green: 0.463, blue: 0.425, alpha: 1.0)
        self.scoreLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.addSubview(self.scoreLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.mainContent)
        
        for i in 0...3 {
            let btn = UIButton()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0 ,weight: UIFont.Weight.bold)

            let expectY = cellper * 2 + cellper * Double(i);
            btn.frame = CGRect(x: cellper * 0.2, y: expectY, width: cellper * 2.8, height: cellper * 0.88);
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            btn.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
            btn.layer.cornerRadius = 6.0
            subContents.append(btn);
        }
        for i in 0 ... 3 {
            self.addSubview(subContents[i])
        }
        
        
        for i in 0...3 {
            let btn = UITextField()
            btn.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.thin)
            let expectY = cellper * 2 + cellper * Double(i);
            btn.frame = CGRect(x: cellper * 3.2, y: expectY, width: cellper * 2.8, height: cellper * 0.88);
            btn.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            btn.textColor = UIColor.black
            btn.addTarget(self, action:#selector(valueChange(_:)), for:.editingDidEnd)
            btn.addTarget(self, action:#selector(valueClear(_:)), for:.editingDidBegin)
            btn.keyboardType = UIKeyboardType.numbersAndPunctuation
            btn.layer.cornerRadius = 6.0
            subVals.append(btn);
        }
        for i in 0 ... 3 {
            self.addSubview(subVals[i])
        }
    }
    
    func whetherValid(item : String, validKeys:Array<String>) -> Bool {
        for va in validKeys {
            if(item.contains(va)){
                return true
            }
        }
        return false
    }
    
    func setImage(img : UIImage, ider : Int, mC:String, mV:Double, sC:Array<String>, sV:Array<Double>, estimate:Double, validKeys:Array<String>) {

            self.imageView.image = img;
            self.BaseId = ider * 10;
            for i in 0 ... 3{
                self.subContents[i].tag = self.BaseId + i;
                self.subVals[i].tag = self.BaseId + 5 + i;
            }
            print("image set")
            
            firstInit = 0;
            var mainStr = String(format: "%1.1f", mV);
            var mainName = mC
        
            if(mainName.contains("生命")){
                mainName = "生命值"
            }
            else if(mainName.contains("攻击")){
                mainName = "攻击力"
            }
        
            if(mV > 100){
                mainStr = String(Int(mV))
            } else {
                mainStr += "%"
            }
            
            if(ider < 7) {
                self.mainContent.setTitle(mainName + " " + mainStr, for: UIControl.State.normal)
                self.mainContent.tag = self.BaseId + 9;
            } else {
                if(ider == 9){
                    self.mainContent.setTitle("吃拐情况", for: UIControl.State.normal)
                } else {
                    self.mainContent.setTitle("圣遗物额外加成", for: UIControl.State.normal)
                }

            }
            

        
            
            var extraindex = 0
            if ider == 9 {
                extraindex = 4
            }
            for ai in 0...3 {
                var i = ai
                var ci = ai + extraindex
                subContents[i].setTitle(sC[ci], for: UIControl.State.normal)
                if(self.whetherValid(item: sC[ci], validKeys: validKeys)){
                    subContents[i].setTitleColor(UIColor.black, for: UIControl.State.normal)
                } else {
                    subContents[i].setTitleColor(UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), for: UIControl.State.normal)
                }
                var str = String(sV[ci])
                if(!sC[ci].contains("小") && !sC[ci].contains("精通")){
                    str += "%"
                } else {
                    str = String(Int(sV[ci]))
                }
                subVals[i].text = "+"+str;
            }
        let score = String(format: "%1.1f", estimate);
        if(estimate < 1){
            self.scoreLabel.text = ""
            self.scoreLabel.backgroundColor = .clear
        } else {
            self.scoreLabel.text = score
        }

    }
    
}

