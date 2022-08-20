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
            let y = Double(i / 2) * 26 + 26
            let btn = UIButton()
            
            btn.frame = CGRect(x: x, y: y, width: perwidth - 2, height: 24)
            btn.tag = 1000 + i
            btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btn.backgroundColor = UIColor (named: "lightgreen")
            btn.setTitle(outkeys[i], for: UIControl.State.normal)
            btn.addTarget(self, action:#selector(tappedColorBtn(_:)), for:.touchUpInside)
            btn.layer.cornerRadius = 12.0
            self.validSubBtns.append(btn)
        }
        for i in 0 ... 6 {
            self.addSubview(self.validSubBtns[i])
        }
        
        totalScoreLabel = UILabel()
        totalScoreLabel.frame = CGRect(x: 0, y: 0, width: perwidth * 2, height: 24)
        totalScoreLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        totalScoreLabel.textColor = UIColor.black
        self.addSubview(totalScoreLabel)
    }
}
