import SwiftUI
import RealityKit
import SpiroCalc

struct SpiroveeKit: UIViewRepresentable {
    @Binding var R: Double
    @Binding var r: Double
    @Binding var d: Double
    @Binding var t: Double
    @Binding var z: Double
    @Binding var desiredPoints: Double
    
    var modeller: KitPathModeler = SphereKitPathModeler()

    func makeCoordinator() -> KitCoordinator {
        return KitCoordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Add default lighting
        arView.environment.lighting.intensityExponent = 1.0
        
        // Add gestures
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(_:)))
        arView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(_:)))
        arView.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleRotation(_:)))
        arView.addGestureRecognizer(rotationGesture)
        
        // Set up initial scene
        setupScene(in: arView, context: context)
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Update the points and refresh the path model
        var points: [SpirographPoint] = [];
        
        measureExecutionTime(label: "calc") {
            points = calculatePoints(R: R, r: r, d: d, zz: z, num_points: Int(desiredPoints))
        }

        measureExecutionTime(label: "update") {
            modeller.update(with: points, scene: self, coordinator: context.coordinator)
        }

        
        // Update state in the coordinator
        context.coordinator.lastD = d
        context.coordinator.lastThickness = t
        context.coordinator.lastZ = z
        context.coordinator.lastPoints = desiredPoints
    }
    
    private func setupScene(in arView: ARView, context: Context) {
        // Create an anchor for the models
        let anchor = AnchorEntity(world: .zero)
        context.coordinator.anchor = anchor
        
        // Add a camera
        let cameraEntity = PerspectiveCamera()
        cameraEntity.position = SIMD3<Float>(0, 0, 5) // Start 5 meters away
        anchor.addChild(cameraEntity)
        context.coordinator.cameraEntity = cameraEntity
        
        // Call the modeller to create the initial path
        modeller.create(scene: self, coordinator: context.coordinator)
        
        // Add anchor to the ARView
        arView.scene.addAnchor(anchor)
    }
}

func measureExecutionTime(label: String, _ block: () -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()
    block()
    let executionTime = CFAbsoluteTimeGetCurrent() - startTime
    print("\(label) Execution time: \(executionTime) seconds")
}

protocol KitPathModeler {
    func create(scene: SpiroveeKit, coordinator: KitCoordinator)
    func update(with points: [SpirographPoint], scene: SpiroveeKit, coordinator: KitCoordinator)
}

class KitCoordinator {
    var anchor: AnchorEntity?
    var cameraEntity: PerspectiveCamera?
    var nodes: [ModelEntity] = []
    var lastD: Double?
    var lastThickness: Double?
    var lastZ: Double?
    var lastPoints: Double?
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let camera = cameraEntity else { return }
            
            let translation = gesture.translation(in: gesture.view)
            let delta = SIMD2<Float>(Float(translation.x), Float(translation.y))
            
            if gesture.state == .changed {
                // Adjust camera position based on pan delta
                camera.position.x -= delta.x * 0.01 // Scale the movement
                camera.position.y += delta.y * 0.01
            }
            
            gesture.setTranslation(.zero, in: gesture.view)
        }

        @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard let camera = cameraEntity else { return }
            
            if gesture.state == .changed {
                // Adjust the camera's Z position to zoom
                camera.position.z /= Float(gesture.scale)
                gesture.scale = 1.0
            }
        }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let camera = cameraEntity else { return }
        
        if gesture.state == .changed {
            // Apply rotation around the Y-axis
            let rotationAngle = Float(gesture.rotation)
            camera.orientation *= simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
            gesture.rotation = 0
        }
    }
}

struct SphereKitPathModeler: KitPathModeler {
    func create(scene: SpiroveeKit, coordinator: KitCoordinator) {
        guard let anchor = coordinator.anchor else {
            print("Anchor not set in coordinator")
            return
        }

        // Generate spheres for initial points
        for _ in 0..<Int(coordinator.lastPoints ?? 10000) {
            let sphere = createSphere(scene: scene)
            anchor.addChild(sphere)
            coordinator.nodes.append(sphere)
        }
    }

    func update(with points: [SpirographPoint], scene: SpiroveeKit, coordinator: KitCoordinator) {
        guard let anchor = coordinator.anchor else {
            print("Anchor not set in coordinator")
            return
        }

        let currentNodeCount = coordinator.nodes.count
        let targetNodeCount = points.count

        // Adjust the number of spheres to match the target points
        if currentNodeCount < targetNodeCount {
            for _ in currentNodeCount..<targetNodeCount {
                let sphere = createSphere(scene: scene)
                anchor.addChild(sphere)
                coordinator.nodes.append(sphere)
            }
        } else if currentNodeCount > targetNodeCount {
            for _ in targetNodeCount..<currentNodeCount {
                if let nodeToRemove = coordinator.nodes.popLast() {
                    nodeToRemove.removeFromParent()
                }
            }
        }

        // Update positions and animations
        for (index, sphere) in coordinator.nodes.enumerated() {
            if index < points.count {
                let point = points[index]
                let position = SIMD3<Float>(Float(point.x), Float(point.y), Float(point.z))

                // Animate the sphere to its new position
                let animationDuration: Float = 0.2
                sphere.move(
                    to: Transform(
                        scale: SIMD3<Float>(Float(scene.t), Float(scene.t), Float(scene.t)),
                        rotation: simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0)), // Identity rotation
                        translation: position
                    ),
                    relativeTo: anchor,
                    duration: TimeInterval(animationDuration)
                )
            }
        }
    }

    private func createSphere(scene: SpiroveeKit) -> ModelEntity {
        let cube = ModelEntity(
            mesh: .generateSphere(radius: Float(scene.t)), // Use `scene.t` for the cube size
            materials: [createMaterial()]
        )
        cube.physicsBody = nil
        cube.position = SIMD3<Float>(0, 0, 0)
        return cube
    }

    private func createMaterial() -> SimpleMaterial {
        let color = SimpleMaterial(color: .blue, isMetallic: false)
        return color
    }
}
