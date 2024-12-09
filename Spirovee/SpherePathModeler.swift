//
//  SpherePathModeler.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/4/24.
//
import SceneKit
import SpiroCalc

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
    
    func create(scene: SpiroveeScene, coordinator : Coordinator) {
        for _ in 0..<Int(coordinator.lastPoints ?? 10000) {
            createSphere(coordinator: coordinator)
        }
    }
    
    func update(with points: [SpirographPoint], scene: SpiroveeScene, coordinator: Coordinator) {

        let currentNodeCount = coordinator.nodes.count
        let targetNodeCount = points.count
        
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
        
        for (index, sphereNode) in coordinator.nodes.enumerated() {
            if let sphereGeometry = sphereNode.geometry as? SCNSphere {
                sphereGeometry.radius = scene.t
            }
            
            let grow = SCNAction.scale(to: scene.t, duration: 0.3)
            let moveToFinal = SCNAction.move(to: SCNVector3(points[index].x, points[index].y,points[index].z), duration: 0.3) // Move to final position
            sphereNode.runAction(SCNAction.sequence([grow, moveToFinal]))
        }

    }
}
