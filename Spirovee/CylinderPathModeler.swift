import SceneKit
import SwiftUI
import SpiroCalc

struct CylinderPathModeler: PathModeler {
    
    func create(scene: SpiroveeScene, coordinator: Coordinator) {
        // Generate a spirograph path for initial creation
        let points = generateDummyPath(pointCount: Int(scene.desiredPoints))
        let geometry = createCylinderAlongPath(points: points, thickness: Float(scene.t))
        
        // Create a node with the generated geometry and add it to the parent
        let cylinderNode = SCNNode(geometry: geometry)
        coordinator.parentNode?.addChildNode(cylinderNode)
        coordinator.nodes = [cylinderNode] // Store the cylinder node in the coordinator
    }
    
    func update(with points: [SpirographPoint], scene: SpiroveeScene, coordinator: Coordinator) {
        guard let cylinderNode = coordinator.nodes.first else { return }
        
        // Update the geometry with new points
        let geometry = createCylinderAlongPath(points: points, thickness: Float(scene.t))
        cylinderNode.geometry = geometry
    }
    
    // Helper to create a smooth cylinder geometry along a path
    private func createCylinderAlongPath(points: [SpirographPoint], thickness: Float) -> SCNGeometry {
        guard points.count > 1 else { return SCNGeometry() }
        
        var vertices: [SCNVector3] = []
        var indices: [UInt32] = []
        
        let radius: Float = thickness // Radius of the cylinder
        let circleSegments = 16 // Smoothness of the cross-section
        
        // Create circular profile
        let profile = createCircularProfile(radius: radius, segmentCount: circleSegments)
        
        // Generate vertices for the cylinder
        for (_, pathPoint) in points.enumerated() {
            for profilePoint in profile {
                let vertex = SCNVector3(
                    Float(pathPoint.x) + profilePoint.x,
                    Float(pathPoint.y) + profilePoint.y,
                    Float(pathPoint.z) + profilePoint.z
                )
                vertices.append(vertex)
            }
        }
        
        // Generate indices for triangle strips
        for i in 0..<(points.count - 1) {
            for j in 0..<circleSegments {
                let current = UInt32(i * circleSegments + j)
                let next = UInt32((i + 1) * circleSegments + j)
                let nextLoop = UInt32(i * circleSegments + (j + 1) % circleSegments)
                let nextLoopNext = UInt32((i + 1) * circleSegments + (j + 1) % circleSegments)
                
                indices.append(contentsOf: [current, next, nextLoop])
                indices.append(contentsOf: [next, nextLoopNext, nextLoop])
            }
        }
        
        // Create geometry sources and elements
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<UInt32>.size)
        let element = SCNGeometryElement(data: indexData, primitiveType: .triangles, primitiveCount: indices.count / 3, bytesPerIndex: MemoryLayout<UInt32>.size)
        
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
        geometry.firstMaterial?.diffuse.contents = UIColor.green
        geometry.firstMaterial?.isDoubleSided = true
        return geometry
    }
    
    // Helper to create a circular profile for the cylinder's cross-section
    private func createCircularProfile(radius: Float, segmentCount: Int) -> [SCNVector3] {
        var profile: [SCNVector3] = []
        for i in 0..<segmentCount {
            let angle = (Float(i) / Float(segmentCount)) * 2.0 * .pi
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            profile.append(SCNVector3(x, y, 0))
        }
        return profile
    }
    
    // Generate a dummy path for testing or initialization
    private func generateDummyPath(pointCount: Int) -> [SpirographPoint] {
        var points: [SpirographPoint] = []
        for i in 0..<pointCount {
            let theta = Double(i) * 0.1
            let x = Double(cos(theta) * 10.0)
            let y = Double(sin(theta) * 10.0)
            points.append(SpirographPoint(x: x, y: y, z: 0))
        }
        return points
    }
}
