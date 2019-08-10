//
//  DVCRender.swift
//  MetalDemo
//
//  Created by YZF on 2019/8/6.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import MetalKit

class DVCRenderer: NSObject, MTKViewDelegate {
    
    var mtkView: MTKView
    
    var device: MTLDevice
    
    var commandQueue: MTLCommandQueue
    
    init(with mtkView: MTKView) {
        self.mtkView = mtkView
        self.device = mtkView.device!
        self.commandQueue = self.device.makeCommandQueue()!
    }
    
    
    /// 当 mtkView 的 contents 的 size 改变时会调用该方法
    /// 使用自动布局时，屏幕旋转也会调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    /// 当需要更新 mtkView 的 contents 是调用该方法
    /// 在这个方法中需要创建一组 GPU Commands 去告诉 GPU 需要在屏幕上显示什么
    /// 可以认为是绘制每一帧你需要展示的一张 image
    func draw(in view: MTKView) {

        // textures 是内存中包含图像数据，如 color、depth、stencil 信息，可以被 GPU 访问的很多数据块。也叫 render targets
        // GPU 会保存处理结果至 textures 中，在显示 contents 时会从获取其中一个 texture 进行渲染
        // MTKView 会创建 textures 去保存需要绘制、显示的内容
        //
        // render pass 是 textures + commands，texture 就是画布，commands 就是各种画笔
        // 为了创建 render pass，需要 renderPassDescriptor，renderPassDescriptor 包含了 textures，以及如何处理 textures（比如自定义的一些 commands，本例中是没有的）
        // 在本例中，renderPassDescriptor 只包含了一个颜色信息，以及在开始 render pass 时清除颜色为 clearColor 这样一个操作
        guard let renderPassDescriptor: MTLRenderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        // 为了生成 render pass，需要将 renderPassDescriptor 编码出所有的 GPU 能处理的 commands 后放入缓冲区
        let commandBuffer: MTLCommandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        // 立刻调用 endEncoding()，因为本例中没有额外的 commands 去处理 texture，仅仅将 texture 清空
        commandEncoder.endEncoding()
        
        // 在 Metal 中通过一个 drawable 对象来管理 textures，通过 drawable 对象的 present 方法来显示 textures
        // 获取 MTKView 自带的 drawable 对象
        let drawable: MTLDrawable = view.currentDrawable!
        
        // 个人理解为添加一条 command（当所有 commands 处理图像完毕后，显示内容）
        commandBuffer.present(drawable)
        // 当前 command 缓冲区 commands 添加完毕，提交处理
        commandBuffer.commit()
    }
    
}
