//
//  DamageCore.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/8/20.
//

import Foundation

struct DamageCore {
    static func getCharactorKeyResultFromBase(base : CharactorBase, charactorName:String) -> String {
        var res = ""
        var cc = base
        switch charactorName {
        case "八重神子":
            var qdamage = cc.qDamage()
            cc.extraDamageRate += cc.elementMastery * 0.15
            var edamage = cc.eDamage()

            res = String(format: "E %1.1f \nQ %1.1f ", edamage, qdamage)
            break
        
        case "甘雨","九条裟罗","七七":
            var qdamage = cc.qDamage()
            var adamageWithOutFire = cc.aDamage()
            cc.element = "冰打火"
            var adamageWithFire = cc.aDamage()
            res = String(format: "纯冰重击 %1.1f \n融化重击 %1.1f \nQ %1.1f ", adamageWithOutFire, adamageWithFire, qdamage)
            break
            
        case "神里绫华":
            var qdamage = cc.qDamage()
            var edamage = cc.eDamage()
            res = String(format: "E %1.1f \nQ %1.1f ", edamage, qdamage)
            break
        default:
            break
        }
        return res
    }
}
