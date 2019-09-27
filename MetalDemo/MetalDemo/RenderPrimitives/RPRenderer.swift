//
//  RPRenderer.swift
//  MetalDemo
//
//  Created by YZF on 2019/8/13.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

import MetalKit
import simd

class RPRenderer: NSObject, MTKViewDelegate {
    
    var mtkView: MTKView
    
    var device: MTLDevice
    
    var commandQueue: MTLCommandQueue
    
    var pipelineState: MTLRenderPipelineState!
    
    var viewportSize: vector_uint2 = vector_uint2()
    
    init(with mtkView: MTKView) {
        self.mtkView = mtkView
        self.device = mtkView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        
        let defaultLibrary: MTLLibrary = self.device.makeDefaultLibrary()!
        // 获取对应的 Vertex Function，即在 metal 文件中声明的方法 vertexShader
        let vertexFunction: MTLFunction = defaultLibrary.makeFunction(name: "vertexShader")!
        // 获取对应的 Fragment Function，即在 metal 文件中声明的方法 fragmentShader
        let fragmentFunction: MTLFunction = defaultLibrary.makeFunction(name: "fragmentShader")!

        let pipelineStateDescriptor: MTLRenderPipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Simple Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        // 设置 render targets 的 pixelFormat，即每个像素在内存中布局的格式
        // 本例中只有一个 render target，并且由 MTKView 提供，因此直接取索引 0 的赋值为 MTKView 的 colorPixelFormat
        // 渲染管线会将 fragment function 输出的内容按照 pixelFormat 的内存排布进行转换
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        
        do {
            self.pipelineState = try self.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print(error)
        }
    }
    
    /// Called whenever view changes orientation or is resized
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportSize.x = UInt32(size.width)
        self.viewportSize.y = UInt32(size.height)
    }
    
    func draw(in view: MTKView) {
        // 声明三个顶点
        let triangleVertices = [RPVertex(position: vector_float2([250, -250]), color: vector_float4([1, 0, 0, 1])),
                                RPVertex(position: vector_float2([-250, -250]), color: vector_float4([0, 1, 0, 1])),
                                RPVertex(position: vector_float2([0, 250]), color: vector_float4([0, 0, 1, 1]))]
        
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        commandBuffer.label = "MyCommand"
        
        if let renderPassDescriptor: MTLRenderPassDescriptor = view.currentRenderPassDescriptor {
            let renderEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
            renderEncoder.label = "MyRenderEncoder"
            
            // 设置可视区域 viewport
            let viewport = MTLViewport(originX: 0, originY: 0, width: Double(self.viewportSize.x), height: Double(self.viewportSize.y), znear: 0, zfar: 1)
            renderEncoder.setViewport(viewport)
            // 设置渲染管线状态对象 pipelineState
            renderEncoder.setRenderPipelineState(self.pipelineState)
            
            // 设置顶点参数，根据 index 的不同对应不同的内存区域
            // 以下两个方法会将参数传入 metal 文件的 Vertex Function 中执行
            renderEncoder.setVertexBytes(triangleVertices, length: MemoryLayout<RPVertex>.size * 3, index: Int(RPVertexInputIndexVertices.rawValue))
            renderEncoder.setVertexBytes(&self.viewportSize, length: MemoryLayout<vector_uint2>.size, index: Int(RPVertexInputIndexViewportSize.rawValue))
            
            // 绘制三角形
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            
            renderEncoder.endEncoding()
            
            commandBuffer.present(view.currentDrawable!)
        }
        
        commandBuffer.commit()
    }
    
}

