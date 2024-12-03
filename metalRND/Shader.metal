//
//  Shader.metal
//  metalRND
//
//  Created by Vishwas Prakash on 03/12/24.
//

#include <metal_stdlib>
using namespace metal;

// Define the struct matching the Swift struct
struct VertexOut {
    float4 position [[position]]; // Position of the vertex
    float4 color;                 // Color of the vertex
};

struct VertexInfo{
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

vertex VertexOut vertex_main(const VertexInfo vertexIn [[stage_in]]) {
    VertexOut out;
    out.position = vertexIn.position;
    out.color = vertexIn.color;
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return in.color;
}
