import SwiftUI

public struct ControlView : View {
    @Binding public var R: Double // Fixed circle radius
    @Binding public var r: Double // Moving circle radius
    @Binding public var d: Double // Distance from center
    @Binding public var t: Double
    @Binding public var z: Double
    @Binding public var points: Double

    public init(R: Binding<Double>, r: Binding<Double>, d: Binding<Double>, t: Binding<Double>, z: Binding<Double>, points: Binding<Double>){
        self._R = R
        self._r = r
        self._d = d
        self._t = t
        self._z = z
        self._points = points
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Fixed Circle (R): \(Int(R))")
            Slider(value: $R, in: 5...50, step: 1)
            
            Text("Moving Circle (r): \(Int(r))")
            Slider(value: $r, in: 5...50, step: 1)
            
            Text("Distance (d): \(Int(d))")
            Slider(value: $d, in: 1...100, step: 1)
            
            Text("Thickness (t): \(t)")
            Slider(value: $t, in: 0...10, step: 0.1)
//
//            Text("Z: \(z)")
//            Slider(value: $z, in: 0...50, step: 1)
            
            Text("Accuracy: \(Int(points))")
            Slider(value: $points, in: 1000...50000, step: 1000)
        }
    }
}
