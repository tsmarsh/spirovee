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
    
    private let desiredPoints = 5000 // Number of spheres to use

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
        createInitialSpheres(parentNode: scene.rootNode, pointCount: desiredPoints, context: context)
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        let points = SpirographCalculator.calculatePoints(R: Int(R), r: Int(r), d: Int(d))
        updateSpherePositions(with: points, context: context)
    }
    
    private func createInitialSpheres(parentNode: SCNNode, pointCount: Int, context: Context) {
        for _ in 0..<pointCount {
            let sphereGeometry = SCNSphere(radius: 0.5)
            sphereGeometry.segmentCount = 8
            sphereGeometry.firstMaterial?.diffuse.contents = UIColor.red
            sphereGeometry.firstMaterial?.emission.contents = UIColor.red // Add emissive effect

            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(0, 0, 0)
            context.coordinator.sphereNodes.append(sphereNode)
            parentNode.addChildNode(sphereNode)
        }
    }
    
    private func updateSpherePositions(with points: [SpirographPoint], context: Context) {
        guard points.count == context.coordinator.sphereNodes.count else {
            print("Mismatch: \(points.count) points, \(context.coordinator.sphereNodes.count) spheres")
            return
        }
        
        for (index, point) in points.enumerated() {
            let sphereNode = context.coordinator.sphereNodes[index]
            
            // Animate the position change for smooth movement
            let newPosition = SCNVector3(point.x, point.y, 0)
            let moveAction = SCNAction.move(to: newPosition, duration: 0.2)
            sphereNode.runAction(moveAction)
        }
    }
}

class Coordinator {
    var sphereNodes: [SCNNode] = []
}
