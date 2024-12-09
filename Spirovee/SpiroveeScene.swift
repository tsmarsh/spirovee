//
//  SceneKitView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//

import SceneKit
import SwiftUI
import SpiroCalc

struct SpiroveeScene: UIViewRepresentable {
    @Binding var R: Double
    @Binding var r: Double
    @Binding var d: Double
    @Binding var t: Double
    @Binding var z: Double
    @Binding var desiredPoints: Double;
    
    var modeller: PathModeler = SpherePathModeler()
    

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
        
        context.coordinator.lastD = d
        context.coordinator.lastThickness = t
        context.coordinator.lastZ = z
        context.coordinator.lastPoints = desiredPoints
        
        // Create initial spheres
        context.coordinator.parentNode = scene.rootNode
        modeller.create(scene: self, coordinator: context.coordinator)
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        let points = calculatePoints(R: R, r: r, d: d, zz: z, num_points: Int(desiredPoints))
        
        modeller.update(with: points, scene: self, coordinator: context.coordinator)
        
        context.coordinator.lastD = d
        context.coordinator.lastThickness = t
        context.coordinator.lastZ = z
        context.coordinator.lastPoints = desiredPoints
    }
}

protocol PathModeler {
    func create(scene: SpiroveeScene, coordinator: Coordinator)
    func update(with points: [SpirographPoint], scene: SpiroveeScene, coordinator: Coordinator)
}

class Coordinator {
    var parentNode: SCNNode?
    var nodes: [SCNNode] = []
    var lastD: Double?
    var lastThickness: Double?
    var lastZ: Double?
    var lastPoints: Double?
}
