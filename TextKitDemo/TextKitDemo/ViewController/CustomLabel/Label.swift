//
//  Label.swift
//  TextKitDemo
//
//  Created by YZF on 2018/7/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class Label: UILabel {

    override var text: String? {
        didSet {
            self.processEditing()
        }
    }
    
    var pattern = "萧炎"
    var expression: NSRegularExpression {
        let expression = try! NSRegularExpression(pattern: pattern, options: [])
        return expression
    }
    
    let textStorage = NSTextStorage()
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    override func drawText(in rect: CGRect) {
        // 绘制背景
        let range = NSMakeRange(0, textStorage.length)
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint.zero)
        
        // 绘制字形
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
    
    func processEditing() {
        guard let text = text else { return }
        
        textStorage.replaceCharacters(in: NSMakeRange(0, textStorage.length), with: NSAttributedString(string: text))
        
        expression.enumerateMatches(in: textStorage.string, options: [], range: NSMakeRange(0, textStorage.length)) { (result, flags, stop) in
            guard let result = result else { return }
            // Add red highlight color
            textStorage.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1), range: result.range)
            textStorage.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: result.range)
        }
    }
    
    // 点击事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        
        // 获取点击了第几个字符
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        expression.enumerateMatches(in: textStorage.string, options: [], range: NSMakeRange(0, textStorage.length)) { (result, flags, stop) in
            guard let result = result else { return }
            if NSLocationInRange(index, result.range) {
                // 点击 “萧炎” 改变字体颜色
                textStorage.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.01186555624, green: 0.515492022, blue: 0.3117238581, alpha: 1), range: result.range)
                self.setNeedsDisplay()
                print("点击萧炎");
            }
        }
    }
}
