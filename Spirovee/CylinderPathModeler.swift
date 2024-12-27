import SceneKit
import SwiftUI
import SpiroCalc

struct CylinderPathModeler: PathModeler {
    private func createCylinder(coordinator: Coordinator){
        let radius = CGFloat(coordinator.lastThickness ?? 0.2)
        
        let cylinder = SCNCylinder(radius: radius, height: 0.1)
        cylinder.firstMaterial?.diffuse.contents = UIColor.lightGray
        cylinder.firstMaterial?.emission.contents = UIColor.blue
        
        let node = SCNNode(geometry: cylinder)
    
        node.position = SCNVector3(0, 0, 0)
        node.opacity = 0.4
        coordinator.nodes.append(node)
        coordinator.parentNode?.addChildNode(node)
    }
    
    func create(scene: any UIViewRepresentable, coordinator : Coordinator) {
        for _ in 0..<Int(coordinator.lastPoints ?? 10000) {
            createCylinder(coordinator: coordinator)
        }
    }
    
    func update(with points: [SpirographPoint], current: ViewState, coordinator: Coordinator, play: Bool) {

        let currentNodeCount = coordinator.nodes.count
        let targetNodeCount = points.count
        
        if currentNodeCount < targetNodeCount {
            // Add more nodes
            for _ in currentNodeCount..<targetNodeCount {
                createCylinder(coordinator: coordinator)
            }
        } else if currentNodeCount > targetNodeCount {
            // Remove excess nodes
            let excessNodes = coordinator.nodes[targetNodeCount..<currentNodeCount]
            for node in excessNodes {
                node.removeFromParentNode() // Remove from scene graph
            }
            coordinator.nodes.removeLast(currentNodeCount - targetNodeCount)
        }
        
            for i in 0..<coordinator.nodes.count - 1 {
                let node = coordinator.nodes[i]
                
                if let geometry = node.geometry as? SCNCylinder {
                    let start = points[i]
                    let end = points[i + 1]
                    
                    let startVector = SCNVector3(Float(start.x), Float(start.y), Float(start.z))
                    let endVector = SCNVector3(Float(end.x), Float(end.y), Float(end.z))
                    
                    // Calculate segment vector and length
                    let segment = endVector - startVector
                    let length = segment.length()
                    
                    geometry.radius = current.t
                    geometry.height = CGFloat(length)
                    
                    let worldTransform = node.presentation.worldTransform
                    // Extract the forward vector from the transform’s third column.
                    // By convention, in SceneKit’s coordinate system, the negative z-axis is the forward direction.
                    let front = SCNVector3(-worldTransform.m13, -worldTransform.m23, -worldTransform.m33)
                    
                    // Normalize the vector to get a unit direction
                    let clength = sqrtf(front.x*front.x + front.y*front.y + front.z*front.z)
                    let localFront = SCNVector3(front.x/clength, front.y/clength, front.z/clength)
                    
                    let direction = (endVector - startVector).normalized()
                    let axis = localFront.cross(direction)
                    let dot = localFront.dot(direction)
                    let angle = acosf(max(min(dot, 1.0), -1.0))
                    
                    let rotation = SCNVector4(axis.x, axis.y, axis.z, angle)
                    
                    let midpoint = (startVector + endVector) * 0.5
                    let moveToFinal = SCNAction.move(to: midpoint, duration: 0.1)
                    let rotateToFinal = SCNAction.rotate(toAxisAngle: rotation, duration: 0.1)
                    let seq = SCNAction.sequence([rotateToFinal, moveToFinal])
                    
                    node.runAction(seq)
                }
            }
        
    }
}

// Vector arithmetic helpers
private extension SCNVector3 {
    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        SCNVector3(lhs.x+rhs.x, lhs.y+rhs.y, lhs.z+rhs.z)
    }
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        SCNVector3(lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z)
    }
    static func *(lhs: SCNVector3, rhs: Float) -> SCNVector3 {
        SCNVector3(lhs.x*rhs, lhs.y*rhs, lhs.z*rhs)
    }
    func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    func normalized() -> SCNVector3 {
        let len = length()
        return SCNVector3(x/len, y/len, z/len)
    }
    func dot(_ v: SCNVector3) -> Float {
        return x*v.x + y*v.y + z*v.z
    }
    func cross(_ v: SCNVector3) -> SCNVector3 {
        return SCNVector3(y*v.z - z*v.y,
                          z*v.x - x*v.z,
                          x*v.y - y*v.x)
    }
}
