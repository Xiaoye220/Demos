//
//  DrawWithAnimation_2.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/8.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawWithAnimation_2: UIView {

    var shapeLayer: CAShapeLayer!
    
    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        self.backgroundColor = UIColor.white
        self.shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let rect = self.bounds.insetBy(dx: 30, dy: 30)
        
        let path = CGMutablePath()
        path.addEllipse(in: rect)
        path.addRect(rect.insetBy(dx: rect.width / 3, dy: rect.height / 3))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + rect.height / 3))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 2 / 3))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        // 添加路径到上下文
        context.addPath(path)
        // 路径的颜色
        context.setStrokeColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        // 路径的宽度
        context.setLineWidth(10)
        // ⚠️⚠️⚠️ 绘制路径，完成后当前上下文的 path 清除
        context.strokePath()
        
        
        shapeLayer.strokeColor = #colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.path = path
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
        
        // 添加动画
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.duration = 5
        anim.fromValue = 0
        anim.toValue = 1
        // 结束后保持在最后一帧
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        
        shapeLayer.add(anim, forKey: nil)
    }


}
