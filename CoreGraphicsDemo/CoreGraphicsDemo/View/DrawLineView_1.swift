//
//  DrawLineView.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawLineView_1: UIView {

    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        self.backgroundColor = UIColor.white
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let rect = self.bounds.insetBy(dx: 30, dy: 30)
        
        // 创建路径
        let linePath1 = CGMutablePath()
        linePath1.move(to: CGPoint.init(x: rect.minX, y: rect.minY))
        linePath1.addLine(to: CGPoint.init(x: rect.maxX, y: rect.minY))
        
        // 添加路径到上下文，每个上下文最多只能有一个 path
        context.addPath(linePath1)
        // 路径的颜色
        context.setStrokeColor(#colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1))
        // 路径的宽度
        context.setLineWidth(5)
        // ⚠️⚠️⚠️ 绘制路径，完成后当前上下文的 path 清除，绘制的路径并不会上下翻转
        context.strokePath()
        
        // 直接在 context 创建路径
        // 在 context 创建一个空的 path
        context.beginPath()
        context.move(to: CGPoint.init(x: rect.minX, y: rect.minY + 50))
        context.addLine(to: CGPoint.init(x: rect.maxX, y: rect.minY + 50))
        
        context.setStrokeColor(#colorLiteral(red: 0.4404723644, green: 0.2396078408, blue: 0.6823841929, alpha: 1))
        context.setLineWidth(5)
        // 线条端点的样式
        context.setLineCap(.round)
        // 线条拐点的样式
        context.setLineJoin(.round)
        // 虚线样式
        context.setLineDash(phase: 0, lengths: [15, 10])
        context.strokePath()
    }
 

}
