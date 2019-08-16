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
    
    var viewportSize: vector_uint2!
    
    init(with mtkView: MTKView) {
        self.mtkView = mtkView
        self.device = mtkView.device!
        self.commandQueue = self.device.makeCommandQueue()!
        
        let defaultLibrary: MTLLibrary = self.device.makeDefaultLibrary()!
        let vertexFunction: MTLFunction = defaultLibrary.makeFunction(name: "vertexShader")!
        let fragmentFunction: MTLFunction = defaultLibrary.makeFunction(name: "vertexShader")!

        let pipelineStateDescriptor: MTLRenderPipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Simple Pipeline"
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        
        do {
            // Pipeline State creation could fail if the pipeline descriptor isn't set up properly.
            //  If the Metal API validation is enabled, you can find out more information about what
            //  went wrong.  (Metal API validation is enabled by default when a debug build is run
            //  from Xcode.)
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
        let triangleVertices = [RPVertex(position: vector_float2([250, -250]), color: vector_float4([1, 0, 0, 1])),
                                RPVertex(position: vector_float2([-250, -250]), color: vector_float4([0, 1, 0, 1])),
                                RPVertex(position: vector_float2([0, 250]), color: vector_float4([0, 0, 1, 1]))]
        
        // Create a new command buffer for each render pass to the current drawable.
        let commandBuffer = self.commandQueue.makeCommandBuffer()!
        commandBuffer.label = "MyCommand"
        
        // Obtain a renderPassDescriptor generated from the view's drawable textures.
        if let renderPassDescriptor: MTLRenderPassDescriptor = view.currentRenderPassDescriptor {
            // Create a render command encoder.
            let renderEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
            renderEncoder.label = "MyRenderEncoder"
            
            // Set the region of the drawable to draw into.
            let viewport = MTLViewport(originX: 0, originY: 0, width: Double(self.viewportSize!.x), height: Double(self.viewportSize!.y), znear: 0, zfar: 1)
            renderEncoder.setViewport(viewport)
            renderEncoder.setRenderPipelineState(self.pipelineState)
            
            // Pass in the parameter data
            renderEncoder.setVertexBytes(triangleVertices, length: MemoryLayout.size(ofValue: triangleVertices), index: Int(RPVertexInputIndexVertices.rawValue))
            renderEncoder.setVertexBytes(&self.viewportSize, length: MemoryLayout.size(ofValue: self.viewportSize), index: Int(RPVertexInputIndexViewportSize.rawValue))
            
            // Draw the triangle.
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            
            renderEncoder.endEncoding()
            
            // Schedule a present once the framebuffer is complete using the current drawable.
            commandBuffer.present(view.currentDrawable!)
        }
        
        commandBuffer.commit()
    }
    
}

