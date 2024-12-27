import SceneKit
import SwiftUI
import SpiroCalc


struct MultiScene: UIViewRepresentable {
    @Binding var state: [ViewState]
    @Binding var play: Bool
    
    var modeller: MultiPathModeler = MultiSphere(modeller: SpherePathModeler())
    

    func makeCoordinator() -> MultiCoordinator {
        return MultiCoordinator()
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
        
        context.coordinator.coordinators = []
        
        for singleState in state {
            let childCoordinator = SpiroveeScene.Coordinator()
            // Set "last known" props from the singleState
            childCoordinator.lastD = singleState.d
            childCoordinator.lastThickness = singleState.t
            childCoordinator.lastZ = singleState.z
            childCoordinator.lastPoints = singleState.num_points
            
            // Optionally store a reference to the parent node or create one:
            childCoordinator.parentNode = scene.rootNode
            
            // Actually create the geometry in the scene for this spiro
            
            // Keep track of this child coordinator in the array
            context.coordinator.coordinators.append(childCoordinator)
        }

        modeller.create(scene: self, coordinator: context.coordinator)
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // 1) Keep coordinators array in sync with state array size
        syncCoordinators(with: uiView, context: context)
        
        // 2) Update each spirograph
        for (index, singleState) in state.enumerated() {
            let points = calculatePoints(
                R: singleState.R,
                r: singleState.r,
                d: singleState.d,
                zz: singleState.z,
                num_points: Int(singleState.num_points)
            )
            
            // Grab the matching child coordinator
            let childCoord = context.coordinator.coordinators[index]
            
            // Update geometry for this specific spiro
            modeller.update(with: points, current: singleState, coordinator: childCoord, play: play)
            
            // Update the child's "last known" parameters (optional)
            childCoord.lastD = singleState.d
            childCoord.lastThickness = singleState.t
            childCoord.lastZ = singleState.z
            childCoord.lastPoints = singleState.num_points
        }
    }
    
    private func syncCoordinators(with uiView: SCNView, context: Context) {
        // If we have *fewer* spiro states than child coordinators, remove the extras
        while context.coordinator.coordinators.count > state.count {
            let removed = context.coordinator.coordinators.removeLast()
            removed.parentNode?.removeFromParentNode()
        }
        
        // If we have *more* spiro states than child coordinators, create new ones
        while context.coordinator.coordinators.count < state.count {
            let newChild = SpiroveeScene.Coordinator()
            newChild.parentNode = uiView.scene?.rootNode
            // Optionally set up initial geometry or call your `modeller.create(...)`
            // if you only do that once in `makeUIView`, you might not need it here.
            
            // Or, if you prefer to re-run `modeller.create(...)` for this new coordinator:
            // modeller.create(scene: self, coordinator: newChild)
            
            context.coordinator.coordinators.append(newChild)
        }
    }
    
}

protocol MultiPathModeler {
    func create(scene: any UIViewRepresentable, coordinator: MultiCoordinator)
    func update(with points: [SpirographPoint], current: ViewState, coordinator: Coordinator, play: Bool)
}

class MultiCoordinator {
    var coordinators: [Coordinator] = []
}
