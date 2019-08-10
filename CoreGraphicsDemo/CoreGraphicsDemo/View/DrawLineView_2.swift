//
//  DrawLineView_2.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawLineView_2: UIView {

    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        self.backgroundColor = UIColor.white
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        super.draw(rect)
        
        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let rect = self.bounds.insetBy(dx: 30, dy: 30)
        
        // 创建圆弧路径
        let linePath1 = CGMutablePath()
        linePath1.addArc(center: CGPoint.init(x: rect.midX, y: rect.minY + 50), radius: 50, startAngle: 0, endAngle: 2 * CGFloat(Float.pi), clockwise: false)
        
        // 添加路径到上下文，每个上下文最多只能有一个 path
        context.addPath(linePath1)
        // 路径的颜色
        context.setStrokeColor(#colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1))
        // 路径的宽度
        context.setLineWidth(5)
        // ⚠️⚠️⚠️ 绘制路径，完成后当前上下文的 path 清除,绘制的路径并不会上下翻转
        context.strokePath()

        // 创建矩形路径
        let linePath2 = CGMutablePath()
        linePath2.addRect(CGRect.init(x: rect.minX, y: rect.minY + 200, width: rect.width, height: 50))

        context.addPath(linePath2)
        context.setStrokeColor(#colorLiteral(red: 0.4404723644, green: 0.2396078408, blue: 0.6823841929, alpha: 1))
        context.setLineWidth(5)
        // 线条拐点的样式
        context.setLineJoin(.round)
        context.strokePath()
    }
    

}
