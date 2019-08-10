//
//  DrawGraphView.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawGraphView_1: UIView {

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
        
        // context 绘制一个圆形的 path
        context.addArc(center: CGPoint.init(x: rect.midX, y: rect.minY + 50), radius: 50, startAngle: 0, endAngle: 2 * CGFloat(Float.pi), clockwise: false)
        context.setStrokeColor(#colorLiteral(red: 0.4404723644, green: 0.2396078408, blue: 0.6823841929, alpha: 1))
        context.setLineWidth(5)
        context.setFillColor(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))
        // ⚠️⚠️⚠️ 绘制 path 并填充，完成后清除上下文 path
        context.drawPath(using: .fillStroke)
        
        
        // 创建圆角矩形路径
        let rectPath = CGMutablePath()
        rectPath.addRoundedRect(in: CGRect.init(x: rect.minX, y: rect.minY + 200, width: rect.width, height: 50), cornerWidth: 10, cornerHeight: 10)
    
        context.addPath(rectPath)
        context.setStrokeColor(#colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1))
        context.setLineWidth(5)
        context.setFillColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
        // 线条拐点的样式
        context.setLineJoin(.round)
        context.drawPath(using: .fillStroke)
    }


}
