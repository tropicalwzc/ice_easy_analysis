//
//  CharactorBase.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/29.
//

import Foundation

class CharactorBase : NSObject {
    
    public var element:String = "冰"
    ///白值+绿值攻击力
    public var attack:Double = 0.0
    public var attackRate = 0.0
    
    ///白值攻击力
    public var whiteAttack:Double = 0.0
    
    public var critChance:Double = 5.0
    public var critDamage:Double = 50.0
    public var elementMastery:Double = 0.0
    public var elementCharge:Double = 100.0
    ///增伤区
    public var extraDamageRate:Double = 0.0
    
    ///突破防御区
    public var defenseReduce = 0.505
    
    ///突破元素抗性区
    public var elementReduce = 90.0
    
    ///元素反应区
    public var reactionRate = 1.0
    
    ///额外攻击力
    public var extraAttack = 0.0
    
    ///魔女如雷额外反应乘区
    public var extraElementMasteryRate = 0.0
    
    ///防御
    public var defense:Double = 0.0
    public var defenseRate = 0.0
    
    ///生命
    public var hitPoint:Double = 0.0
    public var hitPointRate = 0.0
    
    ///治疗
    public var healRate:Double = 0.0
    
    public var eskillRate = 0.0
    public var qskillRate = 0.0
    public var askillRate = 0.0
    
    
    ///申鹤类似拐的方式给予的额外值
    public var externalAtkAreaVal = 0.0
    ///猎人之径
    private var elementaryToExternalATKRate = 0.0
    
    var charactorBaseDict:Dictionary<String,Dictionary<String, String>>!
    var weaponBaseDict:Dictionary<String,Dictionary<String, String>>!
    
    func CalculateRealDamage(skillRate:Double) -> Double {
        var reactionRate = 1.0
        if(element.contains("火打水") || element.contains("冰打火")){
            reactionRate = 1.5 * (1.0 + (extraElementMasteryRate + (2.78 * elementMastery) / (elementMastery + 1400)) )
            print("reactionrate is ",reactionRate)
        } else if(element.contains("水打火") || element.contains("火打冰")){
            reactionRate = 2.0 * (1.0 + (extraElementMasteryRate + (2.78 * elementMastery) / (elementMastery + 1400)) )
        }
        print(attack)
        print(extraDamageRate)
        print(critDamage)
        print(defenseReduce)
        print(skillRate / 100.0)
        
        let res = (attack * (skillRate / 100.0) + externalAtkAreaVal ) * (1.0 + extraDamageRate / 100.0) * (1.0 + critDamage / 100.0) * reactionRate * defenseReduce * transferElementReduceToRealSector()
        return res
    }
    
    func aDamage() -> Double {
        return CalculateRealDamage(skillRate: askillRate)
    }
    func eDamage() -> Double {
        return CalculateRealDamage(skillRate: eskillRate)
    }
    func qDamage() -> Double {
        return CalculateRealDamage(skillRate: qskillRate)
    }
    
    func transferElementReduceToRealSector() -> Double {
        let enemyCurrentResistence = 100 - elementReduce
        if(enemyCurrentResistence < 0) {
            var res = 100.0 - (enemyCurrentResistence / 2)
            res *= 0.01
            return res
        } else if(enemyCurrentResistence < 75) {
            var res = 100.0 - enemyCurrentResistence
            res *= 0.01
            return res
        } else {
            let res = 100.0 / (100 + 4 * enemyCurrentResistence)
            return res
        }
    }
    
    func defenseBreakingBy(breakDefenseVal:Double) -> Double{
        var enemyDefense = 86.0 * 5.0 + 500.0;
        var remainRate = 1.0 - (breakDefenseVal / 100.0)
        enemyDefense *= remainRate
        let res = 950 / (950 + enemyDefense)
        return res
    }
    
    func loadCurrentRelic(cDict : Dictionary<String,String>){
        let orgWhiteAttack = self.attack
        let orgWhiteDefence = self.defense
        let orgWhiteHitPoint = self.hitPoint
        self.addingDictToPad(cDict: cDict)
        let smallAttack = self.attack - orgWhiteAttack
        let smallDefence = self.defense - orgWhiteDefence
        let smallHitPoint = self.hitPoint - orgWhiteHitPoint
        self.attack = orgWhiteAttack
        self.defense = orgWhiteDefence
        self.hitPoint = orgWhiteHitPoint
        self.attack *= (1.0 + attackRate / 100)
        self.hitPoint *= (1.0 + hitPointRate / 100)
        self.defense *= (1.0 + defenseRate/100)
        self.attack += smallAttack
        self.defense += smallDefence
        self.hitPoint += smallHitPoint
        self.attack = round(self.attack)
        self.defense = round(self.defense)
        self.hitPoint = round(self.hitPoint)
        self.externalAtkAreaVal += self.elementaryToExternalATKRate * self.elementMastery
    }
    
    func printCurrentPad() -> Array<Double>{
        let res = [self.critChance,self.critDamage,self.attack,elementCharge,self.elementMastery,self.hitPoint,self.defense,self.extraDamageRate]
        print(attack)
        print(hitPoint)
        print(defense)
        print(critDamage)
        print(critChance)
        print(extraDamageRate)
        return res
    }
    
    func addingDictToPad(cDict : Dictionary<String, String>){
        for item in cDict {
            print(item.key)
            print(item.value)
            switch item.key {
                
            case "小防御":
                fallthrough
            case "防御":
                defense += Double(item.value)!
                break
                
            case "小生命":
                fallthrough
            case "生命":
                hitPoint += Double(item.value)!
                break
                
            case "小攻击":
                fallthrough
            case "攻击":
                attack += Double(item.value)!
                break
                
            case "e":
                eskillRate += Double(item.value)!
                break
            case "a":
                askillRate += Double(item.value)!
                break
            case "q":
                qskillRate += Double(item.value)!
                break
                
            case "暴击伤害":
                fallthrough
            case "暴伤":
                critDamage += Double(item.value)!
                break
                
            case "暴击率":
                critChance += Double(item.value)!
                break
            case "元素精通":
                elementMastery += Double(item.value)!
                break
                
            case "元素伤害":
                fallthrough
            case "物理伤害":
                fallthrough
            case "增伤":
                extraDamageRate += Double(item.value)!
                break
                
            case "破防":
                defenseReduce = self.defenseBreakingBy(breakDefenseVal: Double(item.value)!)
                break
            case "减抗":
                elementReduce += Double(item.value)!
                break
                
            case "大攻击":
                fallthrough
            case "攻击百分比":
                attackRate += Double(item.value)!
                break
                
            case "大防御":
                fallthrough
            case "防御百分比":
                defenseRate += Double(item.value)!
                break
                
            case "大生命":
                fallthrough
            case "生命百分比":
                hitPointRate += Double(item.value)!
                break
            
            case "元素充能":
                fallthrough
            case "充能":
                elementCharge += Double(item.value)!
                break
            
            case "精通转攻击":
                elementaryToExternalATKRate += Double(item.value)! * 0.01
                break
            
            default:
                break
            }
        }
    }
    
    func loadCharactorName(Name:String){
        if let cDict : Dictionary<String,String> = (charactorBaseDict?[Name]) {
            self.addingDictToPad(cDict: cDict)
        }
    }
    
    func loadWeaponName(Name:String){
        if let cDict : Dictionary<String,String> = (weaponBaseDict?[Name]) {
            self.addingDictToPad(cDict: cDict)
        }
    }
    
    
    override init(){
        super.init()
        print("Init now")
        
        let homeDir = NSHomeDirectory()
        print(homeDir)
        let mainBundle = Bundle.main
        let identifer = mainBundle.bundleIdentifier
        let info = mainBundle.infoDictionary

        weaponBaseDict = info?["KnownWeapons"] as? Dictionary<String,Dictionary<String, String>>
        charactorBaseDict = info?["KnownCharactors"] as? Dictionary<String,Dictionary<String, String>>
    }
}
