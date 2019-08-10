//
//  DVCViewController.swift
//  MetalDemo
//
//  Created by YZF on 2019/8/5.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import UIKit
import MetalKit

class DVCViewController: UIViewController {

    var _view: MTKView!
    var _renderer: DVCRenderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        initMTKView()
    }
    
    func initMTKView() {
        _view = MTKView(frame: self.view.frame)
        self.view.addSubview(_view)
        
        // Metal 使用 GPU 能力需要依赖 MTLDevice，一个 MTLDevice 对象代表一个可以执行指令的 GPU
        // MTLDevice 的创建很昂贵、耗时
        // 使用 MTLCreateSystemDefaultDevice() 获取系统默认设备对象，可以根据其是否为 nil 判断当前设备是否支持 Metal
        // 在模拟器上，需要 iOS 13.0 以上，真机需要 iOS 8.0 以上
        _view.device = MTLCreateSystemDefaultDevice()
        
        // 使用一个颜色去清除 view 的 contents，个人感觉应该就是类似 PS 里面油漆桶的功能
        _view.clearColor = MTLClearColorMake(0.0, 0.5, 1.0, 1.0)
        
        // 设置使 view 只有在调用 setNeedsDisplay() 才会进行绘制，避免一些动画
        _view.enableSetNeedsDisplay = true

        // 声明一个 _renderer 对象实现了代理 MTKViewDelegate
        // MTKViewDelegate 用于控制 view 什么时候进行绘制
        _renderer = DVCRenderer(with: _view)
        
        if _renderer == nil {
            print("Renderer initialization failed")
            return
        }
        
        // 该代理方法在 view 的 size 改变时调用
        _renderer.mtkView(_view, drawableSizeWillChange: _view.drawableSize)
        
        _view.delegate = _renderer
    }

}
