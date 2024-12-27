//
//  SpherePathModeler.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/4/24.
//
import SceneKit
import SpiroCalc
import SwiftUI

struct MultiSphere: MultiPathModeler {
    let modeller: PathModeler;
    
    func create(scene: any UIViewRepresentable, coordinator: MultiCoordinator) {
        for subCoordinator in coordinator.coordinators {
            modeller.create(scene: scene, coordinator: subCoordinator)
        }
    }
    
    func update(with points: [SpiroCalc.SpirographPoint], current: ViewState, coordinator: Coordinator, play: Bool) {
        modeller.update(with: points, current: current, coordinator: coordinator, play: play)
    }
}


struct SpherePathModeler: PathModeler {
    private func createSphere(coordinator : Coordinator) {
        let sphereGeometry = SCNSphere(radius: coordinator.lastThickness ?? 0.2)
        sphereGeometry.segmentCount = 8
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.lightGray
        sphereGeometry.firstMaterial?.emission.contents = UIColor.blue

        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = SCNVector3(0, 0, 0)
        sphereNode.opacity = 0.4
        coordinator.nodes.append(sphereNode)
        coordinator.parentNode?.addChildNode(sphereNode)
    }
    
    func create(scene: any UIViewRepresentable, coordinator : Coordinator) {
        print("Creating")
        for _ in 0..<Int(coordinator.lastPoints ?? 10000) {
            createSphere(coordinator: coordinator)
        }
    }
    
    func update(with points: [SpirographPoint], current: ViewState, coordinator: Coordinator, play: Bool) {
        print("Updating")
        
        let currentNodeCount = coordinator.nodes.count
        let targetNodeCount = points.count
        
        print("Points: \(points.count)")
        
        if currentNodeCount < targetNodeCount {
            // Add more nodes
            for _ in currentNodeCount..<targetNodeCount {
                createSphere(coordinator: coordinator)
            }
        } else if currentNodeCount > targetNodeCount {
            // Remove excess nodes
            let excessNodes = coordinator.nodes[targetNodeCount..<currentNodeCount]
            for node in excessNodes {
                node.removeFromParentNode() // Remove from scene graph
            }
            coordinator.nodes.removeLast(currentNodeCount - targetNodeCount)
        }
        
        let playLoop: Double = 3
        let duration = Double(playLoop / Double(points.count))
        
        for (index, sphereNode) in coordinator.nodes.enumerated() {
            if let sphereGeometry = sphereNode.geometry as? SCNSphere {
                sphereGeometry.radius = current.t
            }
            sphereNode.removeAllActions()
            var seq: [SCNAction] = []
            
            if play  {
                seq.append(SCNAction.fadeOut(duration: 0.1))
            } else {
                seq.append(SCNAction.fadeIn(duration: 0.1))
            }
            seq.append(SCNAction.scale(to: current.t, duration: 0.3))
            seq.append(SCNAction.move(to: SCNVector3(points[index].x, points[index].y,points[index].z), duration: 0.3))
            if play {
                seq.append(SCNAction.wait(duration: duration * Double(index)))
                seq.append(SCNAction.fadeIn(duration: 0.2))
                seq.append(SCNAction.wait(duration: 0.1))
                sphereNode.runAction(SCNAction.repeatForever(SCNAction.sequence(seq)))
            } else {
                sphereNode.runAction(SCNAction.sequence(seq))
            }
        }

    }
}
