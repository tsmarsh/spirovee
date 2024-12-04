//
//  Controls.swift
//  Spirovee
//
//  Created by Tom Marsh on 12/3/24.
//
import SwiftUI

struct ControlView : View {
    @Binding var R: Double // Fixed circle radius
    @Binding var r: Double // Moving circle radius
    @Binding var d: Double // Distance from center
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Slider for R
            Text("Fixed Circle (R): \(Int(R))")
            Slider(value: $R, in: 5...50, step: 1)
            
            // Slider for r
            Text("Moving Circle (r): \(Int(r))")
            Slider(value: $r, in: 5...50, step: 1)
            
            // Slider for d
            Text("Distance (d): \(Int(d))")
            Slider(value: $d, in: 1...100, step: 1)
        }
    }
}
