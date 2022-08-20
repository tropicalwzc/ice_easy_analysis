//
//  ScreenUtils.swift
//  ice_analysis
//
//  Created by 王子诚 on 2022/8/20.
//

import Foundation
import UIKit

struct ScreenUtils {
    
    static func getScreenWidth() -> CGFloat {
        let screen = UIScreen.main.bounds.size
        let width = screen.width
        return width
    }
    
    static func getScreenHeight() -> CGFloat {
        let screen = UIScreen.main.bounds.size
        let height = screen.width
        return height
    }
    
    /// 返回屏幕宽高短的那一边
    static func getScreenSmallSideLength() -> CGFloat {
        let screen = UIScreen.main.bounds.size
        let height = screen.width
        let width = screen.width
        return width > height ? height : width
    }
}
