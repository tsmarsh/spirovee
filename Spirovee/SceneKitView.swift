//
//  SceneKitView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//
import SceneKit
import SwiftUI

struct SceneKitView: UIViewRepresentable {
    @Binding var R: Double
    @Binding var r: Double
    @Binding var d: Double
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .black
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Initial spirograph
        updateSpirograph(in: scene)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        guard let scene = uiView.scene else { return }
        updateSpirograph(in: scene)
    }
    
    private func updateSpirograph(in scene: SCNScene) {
        // Remove existing spirograph nodes
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
        // Add updated spirograph
        let spirographNode = createSpirographNode(R: Int(R), r: Int(r), d: Int(d))
        scene.rootNode.addChildNode(spirographNode)
    }
    
    func createSpirographNode(R: Int, r: Int, d: Int) -> SCNNode {
        // Use SpirographCalculator to compute points
        let points = SpirographCalculator.calculatePoints(R: R, r: r, d: d)
        
        print("Generated Points: \(points.count)") // Debugging
        
        // Create a parent node to hold all spheres
        let spirographNode = SCNNode()
        
        // Add a small sphere at each point
        for point in points {
            let sphereGeometry = SCNSphere(radius: 1.0) // Small sphere
            sphereGeometry.segmentCount = 8
            sphereGeometry.firstMaterial?.diffuse.contents = UIColor.red // Make them visible
            
            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(point.x, point.y, 0) // Place sphere at calculated point
            spirographNode.addChildNode(sphereNode)
        }
        
        return spirographNode
    }
}
