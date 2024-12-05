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

struct ContentView: View {

    @State private var R: Double = 30
    @State private var r: Double = 10.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.2
    @State private var z: Double = 10
    @State private var num_points: Double = 10000.0

    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }
        } update: { content in
            // Update the RealityKit content when SwiftUI state changes
            if let scene = content.entities.first {
                let uniformScale: Float = 1.4
                scene.transform.scale = [uniformScale, uniformScale, uniformScale]
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                VStack (spacing: 12) {
                    ControlView(R: $R, r: $r, d: $d, t: $t, z: $r, points: $num_points)
                    
                    .animation(.none, value: 0)
                    .fontWeight(.semibold)

                    ToggleImmersiveSpaceButton()
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(AppModel())
}
