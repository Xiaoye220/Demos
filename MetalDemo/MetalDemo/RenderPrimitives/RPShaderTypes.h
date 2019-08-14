//
//  RPShaderTypes.h
//  MetalDemo
//
//  Created by YZF on 2019/8/13.
//  Copyright © 2019 Xiaoye. All rights reserved.
//

#ifndef RPShaderTypes_h
#define RPShaderTypes_h

#include <simd/simd.h>

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs
// match Metal API buffer set calls.
typedef enum RPVertexInputIndex
{
    RPVertexInputIndexVertices     = 0,
    RPVertexInputIndexViewportSize = 1,
} RPVertexInputIndex;

// 这个结构体定义了顶点的信息
// 该头文件中定义的类型可以被 .metal 文件以及相应的 C 语言文件使用
typedef struct
{
    // vector_float2 是一个包含了两个浮点数的类型，用于表示 x 和 y 轴，取值为 -1 ~ 1
    vector_float2 position;
    // vector_float4 用于表示颜色的 RGBA 信息
    vector_float4 color;
} RPVertex;

#endif /* RPShaderTypes_h */
