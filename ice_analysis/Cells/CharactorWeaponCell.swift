//
//  CharactorWeaponCell.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/31.
//

import Foundation

import UIKit

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}


class CharactorWeaponCell : UICollectionViewCell {
    
    var charactorBtn:UIButton!
    var weaponBtn:UIButton!
    var keyDamageResult:UILabel!
    
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
    
    public func chooseCharactorWeapon(charactor:String, weapon:String){
        var charactorImg = UIImage(imageLiteralResourceName: charactor)
        var weaponImg = UIImage(imageLiteralResourceName: weapon)
        print("Setting images")
        print(charactorImg)
        print(weaponImg)
        charactorImg = charactorImg.scalePreservingAspectRatio(targetSize: CGSize(width: 70, height: 70))
        weaponImg = weaponImg.scalePreservingAspectRatio(targetSize: CGSize(width: 70, height: 70))
        self.charactorBtn.setImage(charactorImg, for: UIControl.State.normal)
        self.weaponBtn.setImage(weaponImg, for: UIControl.State.normal)
    }
    
    public func displayKeyDamage(Content:String){
        self.keyDamageResult.text = Content
    }
    
    func setupUI() {
        
        let smallsidelen = ScreenUtils.getScreenSmallSideLength()
        let cellper = smallsidelen * 0.08
        let perwidth = 3.08 * cellper
        
        for i in 0 ... 1 {
            
            let x = Double(i % 2) * perwidth
            let y = Double(i / 2) * cellper * 1.04
            let btn = UIButton()
            
            btn.frame = CGRect(x: x, y: y, width: perwidth, height: perwidth)
            btn.tag = 2000 + i

            if(i == 0){
                self.charactorBtn = btn
                self.addSubview(self.charactorBtn)
                btn.addTarget(self, action:#selector(tappedColorBtn(_:)), for:.touchUpInside)
            } else {
                self.weaponBtn = btn
                self.addSubview(self.weaponBtn)
                btn.addTarget(self, action:#selector(tappedColorBtn(_:)), for:.touchUpInside)
            }
        }
        
        self.keyDamageResult = UILabel()
        self.keyDamageResult.frame = CGRect(x: 5, y: perwidth, width: perwidth * 2 - 5, height: cellper * 3)
        self.keyDamageResult.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.heavy)
        self.keyDamageResult.textColor = UIColor.gray
        self.keyDamageResult.numberOfLines = 5
        self.keyDamageResult.minimumScaleFactor = 0.1
        self.addSubview(self.keyDamageResult)
    }
}
