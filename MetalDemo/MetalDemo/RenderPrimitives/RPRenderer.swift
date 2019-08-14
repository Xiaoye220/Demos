//
//  RPRenderer.swift
//  MetalDemo
//
//  Created by YZF on 2019/8/13.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import MetalKit

class RPRenderer: NSObject, MTKViewDelegate {
    
    var mtkView: MTKView
    
    var device: MTLDevice
    
    var commandQueue: MTLCommandQueue
    
    init(with mtkView: MTKView) {
        self.mtkView = mtkView
        self.device = mtkView.device!
        self.commandQueue = self.device.makeCommandQueue()!
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        
    }
    
}

