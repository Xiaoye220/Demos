//
//  RPViewController.swift
//  MetalDemo
//
//  Created by YZF on 2019/8/12.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import UIKit
import MetalKit

class RPViewController: UIViewController {
    
    var _view: MTKView!
    var _renderer: RPRenderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        initMTKView()
    }
    
    func initMTKView() {
        _view = MTKView(frame: self.view.frame)
        self.view.addSubview(_view)
        
        _view.device = MTLCreateSystemDefaultDevice()
        
        _view.clearColor = MTLClearColorMake(0.0, 0.5, 1.0, 1.0)
        
        _view.enableSetNeedsDisplay = true
        
        _renderer = RPRenderer(with: _view)
        
        if _renderer == nil {
            print("Renderer initialization failed")
            return
        }
        
        _renderer.mtkView(_view, drawableSizeWillChange: _view.drawableSize)
        
        _view.delegate = _renderer
    }
    
}
