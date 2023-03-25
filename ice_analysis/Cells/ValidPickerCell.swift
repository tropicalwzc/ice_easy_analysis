//
//  ValidPickerCell.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/29.
//

import Foundation
import UIKit

class ValidPickerCell : UICollectionViewCell {
    
    var validSubBtns:Array<UIButton>!
    var totalScoreLabel:UILabel!
    var analysisBtn:UIButton!
    var readBtn:UIButton!
    var saveBtn:UIButton!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @objc func tappedColorBtn(_ button:UIButton){
        print(button.tag)
        postNoti(btn: button.tag)
    }
    
    @objc func tappedAnalysisBtn(_ button:UIButton){
        print(button.tag)
        postNoti(btn: button.tag)
    }
    
    public func flushPickColor(validVals : Array<Double>, totalscore : Double, detailCounts:Dictionary<String,Double>){
        for i in 0 ... 6 {
            if(validVals[i] > 0) {
                self.validSubBtns[i].backgroundColor = UIColor (named: "lightgreen")
            } else {
                self.validSubBtns[i].backgroundColor = UIColor (named: "lightred")
            }
            let orgName = outkeys[i]
            let countval = detailCounts[orgName]
            var fulltitle = String(format: "%@ %1.1f", orgName,countval!)
            self.validSubBtns[i].setTitle(fulltitle, for: UIControl.State.normal)
        }
        let scoreStr = String(format: "总分 %1.1f [%1.1f词]", totalscore, totalscore / 6.6)
        self.totalScoreLabel.text = scoreStr
    }
    
    func setupUI() {
        
        self.validSubBtns = Array<UIButton>()
        
        let smallsidelen = ScreenUtils.getScreenSmallSideLength()
        let cellper = smallsidelen * 0.08
        
        let perwidth = 3.08 * cellper
        for i in 0 ... 6 {
            
            let x = Double(i % 2) * perwidth
            let y = Double(i / 2 + 1) * (cellper * 1.04)
            let btn = UIButton()
            
            btn.frame = CGRect(x: x, y: y, width: perwidth - 2, height: cellper * 0.96)
            btn.tag = 1000 + i
            btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btn.backgroundColor = UIColor (named: "lightgreen")
            btn.setTitle(outkeys[i], for: UIControl.State.normal)
            btn.addTarget(self, action:#selector(tappedColorBtn(_:)), for:.touchUpInside)
            btn.layer.cornerRadius = 8.0
            self.validSubBtns.append(btn)
        }
        for i in 0 ... 6 {
            self.addSubview(self.validSubBtns[i])
        }
        
        totalScoreLabel = UILabel()
        totalScoreLabel.frame = CGRect(x: 0, y: 0, width: perwidth * 2, height: cellper * 0.96)
        totalScoreLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        totalScoreLabel.textColor = UIColor.gray
        
        analysisBtn = UIButton()
        analysisBtn.frame = CGRect(x: perwidth * 1.0, y: 4.16 * cellper, width: perwidth - 2, height: cellper * 0.96)
        analysisBtn.tag = 2002
        analysisBtn.setTitle("评估", for: UIControl.State.normal)
        analysisBtn.addTarget(self, action:#selector(tappedAnalysisBtn(_:)), for:.touchUpInside)
        analysisBtn.backgroundColor = UIColor.gray
        analysisBtn.layer.cornerRadius = 8.0
        
        readBtn = UIButton()
        readBtn.frame = CGRect(x: 0, y: 5.2 * cellper, width: perwidth - 2, height: cellper * 0.96)
        readBtn.tag = 2005
        readBtn.setTitle("读取", for: UIControl.State.normal)
        readBtn.addTarget(self, action:#selector(tappedAnalysisBtn(_:)), for:.touchUpInside)
        readBtn.backgroundColor = UIColor.lightGray
        readBtn.layer.cornerRadius = 8.0
        
        saveBtn = UIButton()
        saveBtn.frame = CGRect(x: perwidth * 1.0, y: 5.2 * cellper, width: perwidth - 2, height: cellper * 0.96)
        saveBtn.tag = 2006
        saveBtn.setTitle("保存", for: UIControl.State.normal)
        saveBtn.addTarget(self, action:#selector(tappedAnalysisBtn(_:)), for:.touchUpInside)
        saveBtn.backgroundColor = UIColor.lightGray
        saveBtn.layer.cornerRadius = 8.0
        
        self.addSubview(totalScoreLabel)
        self.addSubview(analysisBtn)
        self.addSubview(readBtn)
        self.addSubview(saveBtn)
    }
}
