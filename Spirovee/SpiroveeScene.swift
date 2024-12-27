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
    @Binding var state: ViewState
    @Binding var play: Bool
    
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
        
        context.coordinator.lastD = state.d
        context.coordinator.lastThickness = state.t
        context.coordinator.lastZ = state.z
        context.coordinator.lastPoints = state.num_points
        
        // Create initial spheres
        context.coordinator.parentNode = scene.rootNode
        modeller.create(scene: self, coordinator: context.coordinator)
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        let points = calculatePoints(R: state.R, r: state.r, d: state.d, zz: state.z, num_points: Int(state.num_points))
        
        modeller.update(with: points, current: state, coordinator: context.coordinator, play: play)
        
        context.coordinator.lastD = state.d
        context.coordinator.lastThickness = state.t
        context.coordinator.lastZ = state.z
        context.coordinator.lastPoints = state.num_points
    }
}

protocol PathModeler {
    func create(scene: any UIViewRepresentable, coordinator: Coordinator)
    func update(with points: [SpirographPoint], current: ViewState, coordinator: Coordinator, play: Bool)
}

class Coordinator {
    var parentNode: SCNNode?
    var nodes: [SCNNode] = []
    var lastD: Double?
    var lastThickness: Double?
    var lastZ: Double?
    var lastPoints: Double?
}
