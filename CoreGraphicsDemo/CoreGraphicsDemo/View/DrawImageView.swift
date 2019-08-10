//
//  DrawImageView.swift
//  CoreGraphicsDemo
//
//  Created by YZF on 2018/1/5.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import UIKit

class DrawImageView: UIView {

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
        
        let image = UIImage(named: "image")!
        // Core Graphics 坐标系左下为原点，该方法绘制出的图是上下颠倒的
        context.draw((image.cgImage)!, in: CGRect(x: rect.minX + 160, y: rect.minY, width: 150, height: 100))
        // 该方法会自动将坐标系转换好
        image.draw(in: CGRect(x: rect.minX, y: rect.minY, width: 150, height: 100))
        
        // 保存当前 context 状态，⚠️⚠️⚠️ context 坐标系以左下为原点
        context.saveGState()
        // 变换1：坐标系原点向下平移200点
        context.translateBy(x: 0, y: 200)
        // 变换2：缩放成0.5
        context.scaleBy(x: 0.8, y: 0.8)
        // 变换3：旋转10度
        context.rotate(by: CGFloat.pi/18)
        image.draw(in: CGRect(x: rect.minX, y: rect.minY, width: 150, height: 100))

        // 恢复到当初保存的状态
        context.restoreGState()
        
        
        context.saveGState()
        // 将坐标系系上下翻转
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: self.bounds.height)
        context.scaleBy(x: 1, y: -1)
        // 坐标系上下翻转后绘制出来的 image 就是正的
        context.draw((image.cgImage)!, in: CGRect(x: rect.minX + 160, y: rect.minY, width: 120, height: 80))
        
        context.restoreGState()
    }
}
