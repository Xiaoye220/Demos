//
//  DrawGraphView_2.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawGraphView_2: UIView {

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
        
        let mainPath = CGMutablePath()
        
        let subPath1 = CGMutablePath()
        subPath1.addArc(center: CGPoint.init(x: rect.midX, y: rect.minY + 50), radius: 50, startAngle: 0, endAngle: 2 * CGFloat(Float.pi), clockwise: false)
        
        let subPath2 = CGMutablePath()
        subPath2.move(to: CGPoint(x: rect.midX, y: rect.minY + 100))
        subPath2.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 200))
        subPath2.move(to: CGPoint(x: rect.midX - 50, y: rect.minY + 300))
        subPath2.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 200))
        subPath2.addLine(to: CGPoint(x: rect.midX + 50, y: rect.minY + 300))
        subPath2.move(to: CGPoint(x: rect.midX - 50, y: rect.minY + 150))
        subPath2.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 120))
        subPath2.addLine(to: CGPoint(x: rect.midX + 50, y: rect.minY + 150))
        
        // 将 子 path 添加到主 bezierPath 中
        mainPath.addPath(subPath1)
        mainPath.addPath(subPath2)
        
        // context 绘制 bezierPath
        context.addPath(mainPath)
        context.setStrokeColor(#colorLiteral(red: 0.4404723644, green: 0.2396078408, blue: 0.6823841929, alpha: 1))
        context.setLineWidth(5)
        context.setFillColor(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        // ⚠️⚠️⚠️ 绘制 path 并填充，完成后清除上下文 path
        context.strokePath()
        
        
    }
}
