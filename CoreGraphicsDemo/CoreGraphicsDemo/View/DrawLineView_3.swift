//
//  DrawLineView_3.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawLineView_3: UIView {

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
        
        // 创建二次贝塞尔曲线，贝塞尔曲线公式 p = (1-t)^2 * p0 + 2t(1-t) * p1 +t^2 * p2，其中 p0,p1,p2 分别为起点，控制点，终点；p，t可以理解为直角坐标系中的y，x
        let bezierPath1 = UIBezierPath()
        bezierPath1.move(to: CGPoint(x: rect.minX, y: rect.minY + 100))
        //二次贝塞尔曲线终点
        let toPoint = CGPoint(x: rect.maxX, y: rect.minY + 100)
        //二次贝塞尔曲线控制点
        let controlPoint = CGPoint(x: rect.midX, y: rect.minY + 50)
        //绘制二次贝塞尔曲线
        bezierPath1.addQuadCurve(to: toPoint, controlPoint: controlPoint)
        
        // 添加路径到上下文
        context.addPath(bezierPath1.cgPath)
        // 路径的颜色
        context.setStrokeColor(#colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1))
        // 路径的宽度
        context.setLineWidth(5)
        // ⚠️⚠️⚠️ 绘制路径，完成后当前上下文的 path 清除,绘制的路径并不会上下翻转
        context.strokePath()
        
        
        
        
        // 创建三次贝塞尔曲线
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: CGPoint(x: rect.minX, y: rect.minY + 200))
        //三次贝塞尔曲线终点
        let toPoint2 = CGPoint(x: rect.maxX, y: rect.minY + 200)
        //三次贝塞尔曲线两个控制点
        let controlPoint2_1 = CGPoint(x: (rect.midX + rect.minX) / 2, y: rect.minY + 150)
        let controlPoint2_2 = CGPoint(x: (rect.midX + rect.maxX) / 2, y: rect.minY + 250)
        //绘制三次贝塞尔曲线
        bezierPath2.addCurve(to: toPoint2, controlPoint1: controlPoint2_1, controlPoint2: controlPoint2_2)
        
        context.addPath(bezierPath2.cgPath)
        context.setStrokeColor(#colorLiteral(red: 0.4404723644, green: 0.2396078408, blue: 0.6823841929, alpha: 1))
        context.setLineWidth(5)
        context.strokePath()
    }

}
