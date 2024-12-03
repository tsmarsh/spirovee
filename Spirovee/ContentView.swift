//
//  ContentView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var R: Double = 100.0  // Fixed circle radius
    @State private var r: Double = 40.0   // Moving circle radius
    @State private var d: Double = 50.0   // Distance from center
    
    var body: some View {
        VStack {
            // Spirograph View scales with window size
            GeometryReader { geometry in
                SceneKitView(R: Int(R), r: Int(r), d: Int(d))
                    .aspectRatio(1, contentMode: .fit) // Maintain square aspect ratio
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height * 0.95, alignment: .center)
                    .border(Color.gray, width: 1)
            }
            
            // Sliders and labels remain static at the bottom
            ControlView(R: $R,r: $r,d: $d)
            
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
