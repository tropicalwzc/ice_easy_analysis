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
        let cc = base
        
        switch charactorName {
        case "八重神子":
            let qdamage = cc.qDamage()
            cc.extraDamageRate += cc.elementMastery * 0.15
            let edamage = cc.eDamage()

            res = String(format: "E %1.1f \nQ %1.1f ", edamage, qdamage)
            break
        
        case "甘雨","七七":
            let a1damageWithOutFire = cc.qDamage()
            let adamageWithOutFire = cc.aDamage()
            cc.element = "冰打火"
            let adamageWithFire = cc.aDamage()
            let a1damageWithFire = cc.qDamage()
            let totalWithOutFire = a1damageWithOutFire + adamageWithOutFire
            let totalWithFire = a1damageWithFire + adamageWithFire
            let expectWithOutFire = totalWithOutFire * cc.expectRate() * 0.01
            let expectWithFire = totalWithFire * cc.expectRate() * 0.01
            res = String(format: "纯冰重击 一段%1.0f\n二段%1.0f共%1.0f\n融化重击 一段%1.0f\n二段%1.0f共%1.0f\n期望:冰%1.0f融%1.0f ", a1damageWithOutFire,adamageWithOutFire,totalWithOutFire ,a1damageWithFire,adamageWithFire, totalWithFire, expectWithOutFire, expectWithFire)
            break
            
        case "神里绫华":
            let qdamage = cc.qDamage()
            cc.defenseReduce = 0.5
            let edamage = cc.eDamage()
            let orgExtra = cc.extraDamageRate
            cc.extraDamageRate = orgExtra + 328
            let adamage = cc.aDamage()
            cc.extraDamageRate = orgExtra
            // 19 段切割 最后一段为1.5倍的爆炸
            let expectDamage = qdamage * cc.expectRate() * 0.01 * 20.5
            res = String(format: "E %1.0f Z %1.0f \nQ %1.0f\n大卷期望 %1.0f\n大小卷期望 %1.0f ", edamage, adamage, qdamage, expectDamage, expectDamage * 1.4)
            break
            
        case "胡桃":
            cc.element = "火打水"
            let adamage = cc.aDamage()
            let qdamage = cc.qDamage()
            
            res = String(format: "重击 %1.0f期望%1.0f \nQ %1.0f期望%1.0f ", adamage,adamage*cc.expectRate()*0.01 , qdamage, qdamage*(cc.expectRate())*0.01)
            break
            
        case "夜兰":
            let orgAtk = cc.attack
            cc.attack = cc.hitPoint
            let edamage = cc.eDamage()
            let qdamage = cc.qDamage()
            cc.element = "水打火"
            let slimEDamage = cc.eDamage()
            res = String(format: "E %1.0f期望%1.0f\n蒸发%1.0f期望%1.0f\nQ %1.0f期望%1.0f ", edamage,edamage*cc.expectRate()*0.01,slimEDamage,slimEDamage*cc.expectRate()*0.01 , qdamage, qdamage*(cc.expectRate())*0.01)
            cc.attack = orgAtk
            break
        case "珊瑚宫心海":
            let heal = cc.healTotal()
            cc.externalAtkAreaVal = cc.hitPoint * (cc.qskillRate + cc.healRate * 0.15) * 0.01
            let qdamage = cc.aDamage()
            res = String(format: "水母治疗量 %1.0f \nQ普攻一段 %1.0f ", heal, qdamage)
            break
        case "班尼特":
            let ATKmore = cc.bennitATKRate * cc.whiteAttack * 0.01
            let heal = cc.healTotal()
            res = String(format: "攻击力加成 %1.0f \nQ治疗 %1.0f ", ATKmore, heal)
            break
        case "迪奥娜":
            let armour = cc.armourTotal()
            let heal = cc.healTotal()
            res = String(format: "E短按护盾 %1.0f\nE长按护盾 %1.0f\nQ治疗 %1.0f ", armour, armour * 1.75, heal)
            break
        
        case "雷电将军":
            let noHope = cc.eDamage()
            let fullHope = cc.qDamage()
            res = String(format: "0愿力开刀 %1.0f\n满愿力开刀 %1.0f ", noHope, fullHope)
            break
        
        case "九条裟罗":
            let ATKmore = cc.bennitATKRate * cc.whiteAttack * 0.01
            let qdamage = cc.qDamage()
            res = String(format: "攻击力加成 %1.0f \nQ %1.0f ", ATKmore, qdamage)
            
        case "刻晴":
            let edamage = cc.eDamage()
            let qdamage = cc.qDamage()
            res = String(format: "E %1.0f期望%1.0f \nQ %1.0f期望%1.0f ", edamage,edamage*cc.expectRate()*0.01 , qdamage, qdamage*((cc.expectRate() > 85 ? 85 : cc.expectRate()) + 15)*0.01)
            break
        default:
            break
        }
        return res
    }
}
