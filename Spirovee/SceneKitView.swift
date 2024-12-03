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
        let spirographNode = createSpirographNode(R: R, r: r, d: d)
        scene.rootNode.addChildNode(spirographNode)
        
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
        
        print("Generated Points: \(points.count)") // Debugging
        
        // Create a parent node to hold all spheres
        let spirographNode = SCNNode()
        
        // Add a small sphere at each point
        for point in points {
            let sphereGeometry = SCNSphere(radius: 0.5) // Small sphere
            sphereGeometry.firstMaterial?.diffuse.contents = UIColor.red // Make them visible
            
            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(point.x, point.y, 0) // Place sphere at calculated point
            spirographNode.addChildNode(sphereNode)
        }
        
        return spirographNode
    }
}
