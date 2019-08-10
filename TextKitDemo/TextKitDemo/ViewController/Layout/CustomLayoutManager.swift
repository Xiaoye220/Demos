//
//  CustomLayoutManager.swift
//  TextKitDemo
//
//  Created by YZF on 2018/7/3.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class CustomLayoutManager: NSLayoutManager {

    /// 画下划线时调用，即 NSTextStorage 执行 self.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: result.range) 
    /// 可以重写自定义要实现的效果
    override func drawUnderline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
        
        // Left border (== position) of first underlined glyph
        let firstPosition = self.location(forGlyphAt: glyphRange.location).x
        
        // Right border (== position + width) of last underlined glyph
        var lastPosition: CGFloat;
        
        // When link is not the last text in line, just use the location of the next glyph
        // 划下划线的部分在当前行中
        if (NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)) {
            lastPosition = self.location(forGlyphAt: NSMaxRange(glyphRange)).x
        }
            // Otherwise get the end of the actually used rect
        else {
            lastPosition = self.lineFragmentRect(forGlyphAt: NSMaxRange(glyphRange) - 1, effectiveRange: nil).size.width
        }
        
        var underlinedRect = lineRect
        // Inset line fragment to underlined area
        underlinedRect.origin.x = firstPosition + lineRect.origin.x
        underlinedRect.size.width = lastPosition - firstPosition
        
        // Offset line by container origin
        underlinedRect.origin.x = containerOrigin.x + underlinedRect.origin.x
        underlinedRect.origin.y = containerOrigin.y + lineRect.origin.y
        
        // Align line to pixel boundaries, passed rects may be
        underlinedRect.integral.insetBy(dx: 0.5, dy: 0.5)
        
        UIColor.green.set()
        UIBezierPath(rect: underlinedRect).stroke()
    }
    
}
