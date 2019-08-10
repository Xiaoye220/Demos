//
//  UIImage+Extension.swift
//  CoreMLDemo
//
//  Created by YZF on 2018/5/26.
//  Copyright © 2018年 Xiaoye. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func drawBox(in image: UIImage, boundingBox: CGRect) -> UIImage? {
        
        let boxWidth = boundingBox.width * image.size.width
        let boxHeight = boundingBox.height * image.size.height
        let boxX = boundingBox.origin.x * image.size.width
        let boxY = (1 - boundingBox.origin.y) * image.size.height - boxHeight
       
        let rect = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        context.addRect(rect)
        // 路径的颜色
        context.setStrokeColor(#colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1))
        // 路径的宽度
        context.setLineWidth(5)
        // 绘制 box
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func drawPoints(in image: UIImage, points: [[CGPoint]], boundingBox: CGRect) -> UIImage? {
        
        let boxWidth = boundingBox.width * image.size.width
        let boxHeight = boundingBox.height * image.size.height
        let boxX = boundingBox.origin.x * image.size.width
        let boxY = (1 - boundingBox.origin.y) * image.size.height - boxHeight
        
        let realPonits = points.map { point -> [CGPoint] in
            return point.map { point in
                let x = boxX + boxWidth * point.x
                let y = boxY + boxHeight * (1 - point.y)
                return CGPoint(x: x, y: y)
            }
        }
        
        let rect = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        context.addRect(rect)
        // 路径的颜色
        context.setStrokeColor(#colorLiteral(red: 0.7700251937, green: 0.03786655143, blue: 0.1436689794, alpha: 1))
        // 路径的宽度
        context.setLineWidth(5)
        // 绘制 box
        context.strokePath()
        
        // 路径的颜色
        context.setStrokeColor(#colorLiteral(red: 0, green: 0.5176470588, blue: 0, alpha: 1))
        // 路径的宽度
        context.setLineWidth(5)
        
        for points in realPonits {
            context.addLines(between: points);
            context.strokePath()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func scale(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
