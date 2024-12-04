//
//  SceneKitView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//

import SceneKit
import SwiftUI

struct SpiroveeScene: UIViewRepresentable {
    @Binding var R: Double
    @Binding var r: Double
    @Binding var d: Double
    @Binding var t: Double
    
    var modeller: PathModeler = SpherePathModeler()
    
    private let desiredPoints = 10000 // Number of spheres to use

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .black
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Camera setup
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 100) // Move the camera back
        cameraNode.look(at: SCNVector3(0, 0, 0)) // Focus on the origin
        cameraNode.camera?.zNear = 0.1
        cameraNode.camera?.zFar = 5000
        
        scene.rootNode.addChildNode(cameraNode)
        
        // Create initial spheres
        modeller.create(parentNode: scene.rootNode, pointCount: desiredPoints, thickness: t, coordinator: context.coordinator)
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        let points = SpirographCalculator.calculatePoints(R: Int(R), r: Int(r), d: Int(d), num_points: desiredPoints)
        
        let isDChanged = context.coordinator.lastD != d
        
        context.coordinator.lastD = d // Update the last value of d
        
        modeller.update(with: points, isDChanged: isDChanged, thickness: t, coordinator: context.coordinator)
    }
}

protocol PathModeler {
    func create(parentNode: SCNNode, pointCount: Int, thickness: Double, coordinator: Coordinator)
    func update(with points: [SpirographPoint], isDChanged: Bool, thickness: Double, coordinator: Coordinator)
}

class Coordinator {
    var nodes: [SCNNode] = []
    var lastD: Double?
}
