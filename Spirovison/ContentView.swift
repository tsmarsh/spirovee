//
//  ContentView.swift
//  Spirovison
//
//  Created by Tom Marsh on 12/4/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SpiroControls
import SpiroCalc

struct ContentView: View {
    @State private var R: Double = 30
    @State private var r: Double = 12.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.4
    @State private var z: Double = 10
    @State private var num_points: Double = 1000.0

    
    var body: some View {

        GeometryReader3D {
            geometry in
            RealityView { content in
                // Set up the RealityKit scene
                let anchor = AnchorEntity(.head)
                anchor.anchoring.physicsSimulation = .none
                anchor.anchoring.trackingMode = .continuous
                content.add(anchor)

                //addLineGrid(to: anchor, size: 10, spacing: 0.5)
                
                // Generate spirograph points
                let points = calculatePoints(
                    R: Int(R),
                    r: Int(r),
                    d: Int(d),
                    zz: Int(r),
                    num_points: Int(num_points)
                )

                let material = SimpleMaterial(color: .green, isMetallic: false)
                
                print("Points:")
                
                for point in points {
                    let position = SIMD3<Float>(Float(point.x), Float(point.y + 0.5), Float(point.z - 1))
                    
                    print("\(position)");
                    let cube = ModelEntity(
                        mesh: .generateBox(size: Float(t))
                    )
                    cube.position = position
                    anchor.addChild(cube)
                }
                
                
                let sphere = ModelEntity(
                    mesh: .generateSphere(radius: 0.1),
                    materials: [SimpleMaterial(color: .red, isMetallic: false)]
                )
                sphere.position = SIMD3<Float>(0,0.2,-0.2)
                
                // Add multiple directional lights
                let directions = [
                    SIMD3<Float>(3, 3, 10),
                    SIMD3<Float>(-3, 3, 0),
                    SIMD3<Float>(3, -3, 0),
                    SIMD3<Float>(-3, -3, -10)
                ]

                for direction in directions {
                    let directionalLight = DirectionalLight()
                    directionalLight.light.intensity = 500 // Low intensity
                    directionalLight.light.color = .white
                    directionalLight.look(at: SIMD3<Float>(0, 0, 0), from: direction, relativeTo: nil)
                    anchor.addChild(directionalLight)
                }
                
                let ambientLight = PointLight()
                ambientLight.light.intensity = 2000
                ambientLight.position = SIMD3<Float>(0, 2, 0) // Center above the scene
                anchor.addChild(ambientLight)
                
                let camera = PerspectiveCamera()
                camera.position = SIMD3<Float>(0, 1, 5) // Position above and slightly in front of the origin
                camera.look(at: SIMD3<Float>(0, 0, 0), from: camera.position, relativeTo: nil)
                anchor.addChild(camera)
                
            } update: { content in
                let localFrame = geometry.frame(in: .local)
                let sceneFrame = content.convert(localFrame, from: .local, to: .scene)
                
            }
        }
        
//        .toolbar {
//            ToolbarItemGroup(placement: .navigation) {
//                VStack(spacing: 12) {
//                    ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
//                        .animation(.none, value: 0)
//                        .fontWeight(.semibold)
//
//                    ToggleImmersiveSpaceButton()
//                }
//            }
//        }
    }
}

func addLineGrid(to anchor: AnchorEntity, size: Int, spacing: Float) {
    let material = SimpleMaterial(color: .white, isMetallic: false)

    for i in -size...size {
        // Horizontal lines
        let hLine = ModelEntity(mesh: .generateBox(size: SIMD3<Float>(spacing * Float(size * 2), 0.01, 0.01)), materials: [material])
        hLine.position = SIMD3<Float>(0, 0, Float(i) * spacing)
        anchor.addChild(hLine)

        // Vertical lines
        let vLine = ModelEntity(mesh: .generateBox(size: SIMD3<Float>(0.01, 0.01, spacing * Float(size * 2))), materials: [material])
        vLine.position = SIMD3<Float>(Float(i) * spacing, 0, 0)
        anchor.addChild(vLine)
    }
}

#Preview(immersionStyle: .full) {
    ContentView()
        .environment(AppModel())
}
