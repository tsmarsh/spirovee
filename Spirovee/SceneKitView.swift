//
//  SceneKitView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//
import SceneKit
import SwiftUI

struct SceneKitView: UIViewRepresentable {
    let R: Int
    let r: Int
    let d: Int
    
    func makeUIView(context: Context) -> SCNView {
        // Create SceneKit view
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true // Enable user interaction
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .black
        
        // Create and set the scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Add spirograph geometry using SpirographCalculator
//        let spirographNode = createSpirographNode(R: R, r: r, d: d)
//        scene.rootNode.addChildNode(spirographNode)
        
        let cubeGeometry = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        let cubeNode = SCNNode(geometry: cubeGeometry)
        cubeNode.position = SCNVector3(0, 0, 0) // Centered at the origin
        scene.rootNode.addChildNode(cubeNode)
        
        // Add lighting
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(0, 30, 30)
        scene.rootNode.addChildNode(lightNode)
        
        // Add a camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 50)
        scene.rootNode.addChildNode(cameraNode)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
    
    func createSpirographNode(R: Int, r: Int, d: Int) -> SCNNode {
        // Use SpirographCalculator to compute points
        let points = SpirographCalculator.calculatePoints(R: R, r: r, d: d)
        
        print("Generated Points: \(points.count)")
        
        // Create a geometry source from the points
        let vertices = points.map { SCNVector3($0.x, $0.y, 0) }
        let vertexSource = SCNGeometrySource(vertices: vertices)
        
        // Create a line from the points
        var indices: [Int32] = []
        for i in 0..<vertices.count - 1 {
            indices.append(Int32(i))
            indices.append(Int32(i + 1))
        }
        
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<Int32>.size)
        let element = SCNGeometryElement(data: indexData, primitiveType: .line, primitiveCount: indices.count / 2, bytesPerIndex: MemoryLayout<Int32>.size)
        
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        
        return SCNNode(geometry: geometry)
    }
}
