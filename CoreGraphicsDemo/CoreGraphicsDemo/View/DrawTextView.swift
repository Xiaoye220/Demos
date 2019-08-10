//
//  DrawTextView.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawTextView: UIView {

    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        self.backgroundColor = UIColor.white
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect = self.bounds.insetBy(dx: 30, dy: 30)
        
        //文字样式属性
        var attributes: [NSAttributedStringKey: Any] = [:]
        attributes[.font] = UIFont.systemFont(ofSize: 20)
        attributes[.foregroundColor] = #colorLiteral(red: 0, green: 0.5176470588, blue: 0, alpha: 1)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        attributes[.paragraphStyle] = style
        
        // 创建需要绘制的 NSAttributedString
        let attrStr = NSAttributedString(string: "绘制Text", attributes: attributes)
        
        // 在当前 current context 绘制
        attrStr.draw(in: rect)
    }

}
