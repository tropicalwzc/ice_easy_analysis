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
            let a1damageWithOutFire = cc.qDamage()
            let adamageWithOutFire = cc.aDamage()
            cc.element = "冰打火"
            let adamageWithFire = cc.aDamage()
            let a1damageWithFire = cc.qDamage()
            let totalWithOutFire = a1damageWithOutFire + adamageWithOutFire
            let totalWithFire = a1damageWithFire + adamageWithFire
            let expectWithOutFire = totalWithOutFire * cc.critChance * 0.01
            let expectWithFire = totalWithFire * cc.critChance * 0.01
            res = String(format: "纯冰重击 一段%1.0f\n二段%1.0f共%1.0f\n融化重击 一段%1.0f\n二段%1.0f共%1.0f\n期望:冰%1.0f融%1.0f ", a1damageWithOutFire,adamageWithOutFire,totalWithOutFire ,a1damageWithFire,adamageWithFire, totalWithFire, expectWithOutFire, expectWithFire)
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
