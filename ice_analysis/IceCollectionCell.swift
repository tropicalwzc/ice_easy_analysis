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
    
    /// 发送通知
    func postNoti(btn : Int) -> Void {
        let info = ["body":btn]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewNotiSecond"), object: nil, userInfo: info )
        print("begin post")
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
        
        self.imageView.frame = CGRect(x: 10.0, y: 50.0, width: 50, height: 50);
        self.mainContent.frame = CGRect(x: 10.0, y: 0.0, width: 120, height: 50);
        self.mainContent.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.mainContent.setTitleColor(UIColor.black, for: UIControl.State.normal)
        self.mainContent.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        self.mainContent.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
        
        self.scoreLabel.frame = CGRect(x: 125.0, y: 0.0, width: 25, height: 25);
        self.scoreLabel.textColor =  UIColor(red: 0.972, green: 0.863, blue: 0.565, alpha: 1.0)
        self.scoreLabel.backgroundColor = UIColor.lightGray
        self.scoreLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.addSubview(self.scoreLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.mainContent)
        
        for i in 0...3 {
            let btn = UIButton()
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 10.0 ,weight: UIFont.Weight.bold)

            let expectY = 50 + 22.0 * Double(i);
            btn.frame = CGRect(x: 60, y: expectY, width: 45, height: 20.0);
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
            btn.addTarget(self, action:#selector(tapped(_:)), for:.touchUpInside)
            subContents.append(btn);
        }
        for i in 0 ... 3 {
            self.addSubview(subContents[i])
        }
        
        
        for i in 0...3 {
            let btn = UITextField()
            btn.font = UIFont.systemFont(ofSize: 12.0)
            let expectY = 50 + 22.0 * Double(i);
            btn.frame = CGRect(x: 105, y: expectY, width: 45, height: 20.0);
            btn.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            btn.textColor = UIColor.black
            btn.addTarget(self, action:#selector(valueChange(_:)), for:.editingDidEnd)
            btn.addTarget(self, action:#selector(valueClear(_:)), for:.editingDidBegin)
            btn.keyboardType = UIKeyboardType.numbersAndPunctuation
            subVals.append(btn);
        }
        for i in 0 ... 3 {
            self.addSubview(subVals[i])
        }
    }
    
    func reflush()
    {
        self.addSubview(self.scoreLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.mainContent)
        for i in 0 ... 3 {
            self.addSubview(subContents[i])
        }
        for i in 0 ... 3 {
            self.addSubview(subVals[i])
        }
    }
    
    func setImage(img : UIImage, ider : Int, mC:String, mV:Double, sC:Array<String>, sV:Array<Double>) {

            self.imageView.image = img;
            self.BaseId = ider * 10;
            for i in 0 ... 3{
                self.subContents[i].tag = self.BaseId + i;
                self.subVals[i].tag = self.BaseId + 5 + i;
            }
            print("image set")
            
            firstInit = 0;
            var mainStr = String(mV);
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
            self.mainContent.setTitle(mainName + " " + mainStr, for: UIControl.State.normal)
            self.mainContent.tag = self.BaseId + 9;
        
            for i in 0...3 {
                subContents[i].setTitle(sC[i], for: UIControl.State.normal)
                if(sC[i].contains("防御") || sC[i].contains("生命")){
                    subContents[i].setTitleColor(UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), for: UIControl.State.normal)
                } else {
                    subContents[i].setTitleColor(UIColor.black, for: UIControl.State.normal)
                }
                var str = String(sV[i])
                if(!sC[i].contains("小") && !sC[i].contains("精通")){
                    str += "%"
                } else {
                    str = String(Int(sV[i]))
                }
                subVals[i].text = "+"+str;
            }
        let score = String(25);
        self.scoreLabel.text = score
    }
    
}

