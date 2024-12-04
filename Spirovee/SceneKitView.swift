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
        let points = SpirographCalculator.calculatePoints(R: Int(R), r: Int(r), d: Int(d), num_points: desiredPoints)
        
        let isDChanged = context.coordinator.lastD != d
        
        context.coordinator.lastD = d // Update the last value of d
        
        updateSpherePositions(with: points, isDChanged: isDChanged, context: context)
    }
    
    private func createInitialSpheres(parentNode: SCNNode, pointCount: Int, context: Context) {
        for _ in 0..<pointCount {
            let sphereGeometry = SCNSphere(radius: 0.5)
            sphereGeometry.segmentCount = 8
            sphereGeometry.firstMaterial?.diffuse.contents = UIColor.lightGray
            sphereGeometry.firstMaterial?.emission.contents = UIColor.blue // Add emissive effect

            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(0, 0, 0)
            context.coordinator.sphereNodes.append(sphereNode)
            parentNode.addChildNode(sphereNode)
        }
    }
    
    private func updateSpherePositions(with points: [SpirographPoint], isDChanged: Bool, context: Context) {
        guard points.count == context.coordinator.sphereNodes.count else {
            print("Mismatch: \(points.count) points, \(context.coordinator.sphereNodes.count) spheres")
            return
        }
        
        if (isDChanged){
            for (index, sphereNode) in context.coordinator.sphereNodes.enumerated() {
                let moveToFinal = SCNAction.move(to: SCNVector3(points[index].x, points[index].y, 0), duration: 0.2) // Move to final position
                sphereNode.runAction(moveToFinal)
            }
        } else {
            for (index, sphereNode) in context.coordinator.sphereNodes.enumerated() {
                let reset = SCNAction.run { _ in
                    sphereNode.position = SCNVector3(0, 0, 0)
                    sphereNode.opacity = 0.0
                }
                
                let point = points[index]

                // Animation sequence
                let delay = Double(index) * 0.01 // Incremental delay for drawing effect

                let makeInvisible = SCNAction.fadeOut(duration: 0.05)
                
                let moveToFinal = SCNAction.move(to: SCNVector3(point.x, point.y, 0), duration: 0.0)
                
                let wait = SCNAction.wait(duration: delay)
                
                let fadeIn = SCNAction.fadeIn(duration: 0.5)
                
                let hold = SCNAction.wait(duration: 10.0)//Double(desiredPoints) * 0.01 * 3)
                
                let sequence = SCNAction.sequence([makeInvisible, moveToFinal, wait, fadeIn])
                let loop = SCNAction.repeatForever(sequence)
                
                // Run the animation
                sphereNode.runAction(SCNAction.sequence([reset, sequence]))
            }
        }

    }
}

class Coordinator {
    var sphereNodes: [SCNNode] = []
    var lastD: Double?
}
