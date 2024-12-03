//
//  ContentView.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var R: Double = 100  // Fixed circle radius
    @State private var r: Double = 40   // Moving circle radius
    @State private var d: Double = 50   // Distance from center
    
    var body: some View {
        VStack {
            SpirographView(R: R, r: r, d: d)
                .frame(width: 300, height: 300)
                .border(Color.gray, width: 1)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Fixed Circle (R): \(Int(R))")
                Slider(value: $R, in: 50...150)
                
                Text("Moving Circle (r): \(Int(r))")
                Slider(value: $r, in: 10...80)
                
                Text("Distance (d): \(Int(d))")
                Slider(value: $d, in: 10...100)
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}
