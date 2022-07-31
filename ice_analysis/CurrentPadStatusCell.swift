//
//  CurrentPadStatusCell.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/31.
//

import Foundation
import UIKit

class CurrentPadStatusCell : UICollectionViewCell {
    
    var validSubBtns:Array<UIButton>!
    var realFlushVals:Array<UILabel>!
    var totalScoreLabel:UILabel!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    public func loadPadDatas(validVals : Array<Double>){
        for i in 0 ... 7 {
            let orgName = outkeys[i]
            var fulltitle = String(format: "%1.1f", validVals[i])
            self.realFlushVals[i].text = fulltitle
        }
    }
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 0.1)
    }
    
    func setupUI() {
        
        self.validSubBtns = Array<UIButton>()
        self.realFlushVals = Array<UILabel>()
        
        let perwidth = 154.0
        for i in 0 ... 7 {
            
            let x = 0.0
            let y = Double(i) * 19
            let btn = UIButton()
            let realFlush = UILabel()
            
            var btnwid = 40.0
            
            btn.frame = CGRect(x: x, y: y, width: btnwid, height: 18)
            btn.tag = 1000 + i
            btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btn.backgroundColor = UIColor (named: "diffgreen")
            btn.setTitle(outkeys[i], for: UIControl.State.normal)
            self.validSubBtns.append(btn)
            
            realFlush.frame = CGRect(x: btnwid + 1, y: y, width: perwidth - btnwid, height: 18)
            realFlush.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
            realFlush.backgroundColor = self.randomColor()
            self.realFlushVals.append(realFlush)
        }
        for i in 0 ... 7 {
            self.addSubview(self.validSubBtns[i])
            self.addSubview(self.realFlushVals[i])
        }
    }
}
