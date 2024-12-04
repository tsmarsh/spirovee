//
//  SpherePathModeler.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/4/24.
//
import SceneKit

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
        
        if (scene.d != coordinator.lastD || scene.z != coordinator.lastZ || scene.t != coordinator.lastThickness){
            for (index, sphereNode) in coordinator.nodes.enumerated() {
                if let sphereGeometry = sphereNode.geometry as? SCNSphere {
                    sphereGeometry.radius = scene.t
                }
                
                let moveToFinal = SCNAction.move(to: SCNVector3(points[index].x, points[index].y,points[index].z), duration: 0.2) // Move to final position
                sphereNode.runAction(moveToFinal)
            }
        } else {
            for (index, sphereNode) in coordinator.nodes.enumerated() {
                if let sphereGeometry = sphereNode.geometry as? SCNSphere {
                    sphereGeometry.radius = scene.t
                }
                
                let reset = SCNAction.run { _ in
                    sphereNode.position = SCNVector3(0, 0, 0)
                    sphereNode.opacity = 0.0
                }
                
                let point = points[index]

                // Animation sequence
                let delay = Double(index) * (2.0 / Double(points.count)) // Incremental delay for drawing effect

                let makeInvisible = SCNAction.fadeOut(duration: 0.05)
                
                let moveToFinal = SCNAction.move(to: SCNVector3(point.x, point.y, point.z), duration: 0.0)
                
                let wait = SCNAction.wait(duration: delay)
                
                let fadeIn = SCNAction.fadeOpacity(to: 0.4, duration: 0.5)
                
                let hold = SCNAction.wait(duration: 5.0)//Double(desiredPoints) * 0.01 * 3)
                
                let sequence = SCNAction.sequence([makeInvisible, moveToFinal, wait, fadeIn, hold])
                // let loop = SCNAction.repeatForever(sequence)
                
                // Run the animation
                sphereNode.runAction(SCNAction.sequence([reset, sequence]))
            }
        }

    }
}
