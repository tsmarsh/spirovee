import SwiftUI
import RealityKit
import RealityKitContent
import SpiroCalc
import SpiroControls

struct ImmersiveView: View {

    @State private var R: Double = 30
    @State private var r: Double = 12.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.01
    @State private var z: Double = 10
    @State private var num_points: Double = 3000.0

    var body: some View {
        RealityView { content in
            // Set up the RealityKit scene
            let anchor = AnchorEntity(world: .zero)
            content.add(anchor)

            // Generate spirograph points
            let points = calculatePoints(
                R: Int(R),
                r: Int(r),
                d: Int(d),
                zz: Int(r),
                num_points: Int(num_points)
            )

            let material = SimpleMaterial(color: .green, isMetallic: false)
            
            for point in points {
                let position = SIMD3<Float>(Float(point.x), Float(point.y + 1.3), Float(point.z - 1))
                
                let cube = ModelEntity(
                    mesh: .generateBox(size: Float(t)),
                    materials: [material]
                )
                cube.position = position
                anchor.addChild(cube)
            }
            
            // Add multiple directional lights
            let directions = [
                SIMD3<Float>(10, 10, 10),
                SIMD3<Float>(-10, 10, 10),
                SIMD3<Float>(10, -10, 10),
                SIMD3<Float>(-10, -10, 10)
            ]

            for direction in directions {
                let directionalLight = DirectionalLight()
                directionalLight.light.intensity = 300 // Low intensity
                directionalLight.light.color = .white
                directionalLight.look(at: SIMD3<Float>(0, 0, 0), from: direction * 10, relativeTo: nil)
                anchor.addChild(directionalLight)
            }
        }.toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                VStack(spacing: 12) {
                    ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
                        .animation(.none, value: 0)
                        .fontWeight(.semibold)

                    ToggleImmersiveSpaceButton()
                }
            }
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
