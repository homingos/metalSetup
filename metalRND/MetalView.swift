//
//  MetalView.swift
//  metalRND
//
//  Created by Vishwas Prakash on 03/12/24.
//
import MetalKit
import simd

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

class MetalView: MTKView {
    private var metalDevice: MTLDevice!
    private var commandQueue: MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!
    private var indexBuffer: MTLBuffer!
    
    let index: [UInt16] = [
        0, 1, 2,
        2, 3, 0
    ]

    required init(coder: NSCoder) {
        super.init(coder: coder)
        initializeMetal()
        createPipeline()
        createVertexBuffer()
    }
    
    override init(frame: CGRect, device: MTLDevice?) {
        super.init(frame: frame, device: device)
        initializeMetal()
        createPipeline()
        createVertexBuffer()
    }

    private func initializeMetal() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        metalDevice = device
        commandQueue = metalDevice.makeCommandQueue()
        self.device = metalDevice
        self.colorPixelFormat = .bgra8Unorm
    }
    
    private func createVertexBuffer() {
        let vertices: [Vertex] = [
            // Second rectangle (double the size, centered)
            Vertex(position: SIMD3(-0.5,  0.5, 0.0), color: SIMD4(0.0, 1.0, 0.0, 1.0)),  // Top-left
            Vertex(position: SIMD3(-0.5, -0.5, 0.0), color: SIMD4(0.0, 1.0, 0.0, 1.0)),  // Bottom-left
            Vertex(position: SIMD3( 0.5, -0.5, 0.0), color: SIMD4(0.0, 1.0, 0.0, 1.0)),  // Bottom-right
            Vertex(position: SIMD3( 0.5,  0.5, 0.0), color: SIMD4(0.0, 1.0, 0.0, 1.0)),  // Top-right

            // First rectangle (scaled down to half)
            Vertex(position: SIMD3(-0.25,  0.25, 0.0), color: SIMD4(1.0, 0.0, 0.0, 1.0)),  // Top-left
            Vertex(position: SIMD3(-0.25, -0.25, 0.0), color: SIMD4(1.0, 0.0, 0.0, 1.0)),  // Bottom-left
            Vertex(position: SIMD3( 0.25, -0.25, 0.0), color: SIMD4(1.0, 0.0, 0.0, 1.0)),  // Bottom-right
            Vertex(position: SIMD3( 0.25,  0.25, 0.0), color: SIMD4(1.0, 0.0, 0.0, 1.0))   // Top-right
        ]
        
        let indices: [UInt16] = [
            // First rectangle
            0, 1, 2,
            2, 3, 0,
            
            // Second rectangle
            4, 5, 6,
            6, 7, 4
        ]

        vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = metalDevice.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }

    private func createPipeline() {
        let library = metalDevice.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride

        pipelineDescriptor.vertexDescriptor = vertexDescriptor

        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    override func draw(_ rect: CGRect) {
        guard let drawable = currentDrawable,
              let renderPassDescriptor = currentRenderPassDescriptor else {
            return
        }

        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)

        renderEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: 6, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0) // First rectangle
            renderEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: 6, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 6 * MemoryLayout<UInt16>.size) // Second rectangle
        renderEncoder?.endEncoding()

        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

