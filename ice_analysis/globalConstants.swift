//
//  globalConstants.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/7/29.
//

import Foundation

let nameOrdered = ["flower","feather","sand","cup","hat"]
let outkeys = ["暴击","暴伤","攻击","充能","精通", "生命","防御"]

let reuseIdentifier = "CECell";
let reusePickerIdentifier = "CEPickerCell";

/// 发送通知
func postNoti(btn : Int) -> Void {
    let info = ["body":btn]
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "viewNotiSecond"), object: nil, userInfo: info )
    print("begin post")
}
