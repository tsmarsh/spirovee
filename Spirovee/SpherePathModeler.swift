//
//  SpherePathModeler.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/4/24.
//
import SceneKit

struct SpherePathModeler: PathModeler {
    func create(parentNode: SCNNode, pointCount: Int, thickness: Double, coordinator : Coordinator) {
        for _ in 0..<pointCount {
            let sphereGeometry = SCNSphere(radius: thickness)
            sphereGeometry.segmentCount = 8
            sphereGeometry.firstMaterial?.diffuse.contents = UIColor.lightGray
            sphereGeometry.firstMaterial?.emission.contents = UIColor.blue // Add emissive effect

            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(0, 0, 0)
            coordinator.nodes.append(sphereNode)
            parentNode.addChildNode(sphereNode)
        }
    }
    
    func update(with points: [SpirographPoint], isDChanged: Bool, thickness: Double, coordinator: Coordinator) {
        guard points.count == coordinator.nodes.count else {
            print("Mismatch: \(points.count) points, \(coordinator.nodes.count) spheres")
            return
        }
        
        
        if (isDChanged){
            for (index, sphereNode) in coordinator.nodes.enumerated() {
                if let sphereGeometry = sphereNode.geometry as? SCNSphere {
                    sphereGeometry.radius = thickness
                }
                
                let moveToFinal = SCNAction.move(to: SCNVector3(points[index].x, points[index].y,points[index].z), duration: 0.2) // Move to final position
                sphereNode.runAction(moveToFinal)
            }
        } else {
            for (index, sphereNode) in coordinator.nodes.enumerated() {
                if let sphereGeometry = sphereNode.geometry as? SCNSphere {
                    sphereGeometry.radius = thickness
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
                
                let fadeIn = SCNAction.fadeIn(duration: 0.5)
                
                let hold = SCNAction.wait(duration: 5.0)//Double(desiredPoints) * 0.01 * 3)
                
                let sequence = SCNAction.sequence([makeInvisible, moveToFinal, wait, fadeIn, hold])
                // let loop = SCNAction.repeatForever(sequence)
                
                // Run the animation
                sphereNode.runAction(SCNAction.sequence([reset, sequence]))
            }
        }

    }
}
