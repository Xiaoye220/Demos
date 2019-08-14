//
//  RPShaders.metal
//  MetalDemo
//
//  Created by YZF on 2019/8/13.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include "RPShaderTypes.h"

// 顶点着色器阶段处理后完，要进入片段着色器需要的一个数据类型
typedef struct
{
    // 表示顶点着色器阶段经过 vertex function 处理后的位置信息
    // 这里会将原先 vector_float2 类型的 position 转换成 float4 的 position，即将二元向量转换为四元向量
    // [[position]] 修饰符用于声明该参数表示的是 position 信息
    float4 position [[position]];
    
    // 这里的颜色会根据顶点的颜色进行插值计算
    // float4 等价于 RPVertex 中的 vector_float4
    float4 color;
    
} RasterizerData;

// vertex 关键字声明 vertex Function，根据输入的顶点信息输出 RasterizerData
// [[vertex_id]] 修饰符是一个 Metal 关键字，GPU 每次调用该方法时会传入一个唯一值作为 id
// [[buffer(n)]] 修饰符
// 参数 vertices 就是一个 RPVertex 数组
// 参数 viewportSizePointer 表示一个三角形会被绘制的区域，该例中即为整个屏幕区域
vertex RasterizerData
vertexShader(uint vertexID [[vertex_id]],
             constant RPVertex *vertices [[buffer(RPVertexInputIndexVertices)]],
             constant vector_uint2 *viewportSizePointer [[buffer(RPVertexInputIndexViewportSize)]])
{
    RasterizerData out;
    
    // 根据 vertexID 从 vertices 获取当前的顶点 x 和 y 轴信息
    float2 pixelSpacePosition = vertices[vertexID].position.xy;
    
    // 获取三角形会被绘制的区域
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    
    // 这里的 position 转换，需要将二元向量，处理为四元向量（xyzw）。
    // 只是三角形是基于二维平面的，所以我们用到 xy 即可，zw 固定设置成（0.0, 1.0）即可
    // z 轴一般用来描述深度，它代表一个像素在空间中和你的距离，因为我们要放在平面上，所以设置成 0。没有特殊操作的情况下，W 轴默认都设置为 1.0
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    
    // 这里是将坐标系转换成一个左下角为 （-1，-1） 右上角为（1， 1）的坐标系，即 x 和 y 的值均为 -1 ~ 1
    // 比如 viewportSize 为 （1000， 1000），那么整个坐标系就是一个左下角为（-500， -500）右上角为（500，500）的坐标系
    // 假设 pixelSpacePosition 为 （-250， -250），那么转换后的 xy 坐标为（-0.5，-0.5）
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);
    
    // 拷贝 color 至 out 中
    out.color = vertices[vertexID].color;
    
    return out;
}

// fragment 关键字声明 fragment function
// [[stage_in]] 修饰符声明该参数是光栅化后输出的值
// 光栅化会对每个像素计算出相应的 RasterizerData 后将其作为参数调用 fragment function
fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // 光栅化会根据顶点颜色对每个片段进行插值处理，获取对应的颜色
    return in.color;
}
