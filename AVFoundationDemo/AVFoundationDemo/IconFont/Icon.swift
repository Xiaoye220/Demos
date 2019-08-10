//
//  IconFont.swift
//  AVFoundationDemo
//
//  Created by YZF on 2017/12/25.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import YFIconFont

public enum Icon: String {
    case dismiss = "\u{e61b}"
    case camera = "\u{e6ad}"
    case check = "\u{e627}"
    case adjust = "\u{e703}"
    case back = "\u{e67f}"
    case focus = "\u{e626}"
}

extension Icon: IconFontType {
    
    public static var fontFilePath: String? = Bundle.main.path(forResource: "iconfont", ofType: "ttf")
    
    public static var fontName: String {
        return "iconfont"
    }
    
    public var unicode: String {
        return self.rawValue
    }
}
