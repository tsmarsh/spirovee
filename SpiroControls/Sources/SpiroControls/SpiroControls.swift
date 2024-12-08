import SwiftUI

@available(iOS 13.0, *)
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
            Text("Fixed Circle:")
            Slider(value: $R, in: 5...50, step: 1)
            
            Text("Moving Circle:")
            Slider(value: $r, in: 5...50, step: 1)
            
            Text("Distance:")
            Slider(value: $d, in: 1...100, step: 1)
            
            Text("Thickness:")
            Slider(value: $t, in: 0...1, step: 0.01)
//
//            Text("Z: \(z)")
//            Slider(value: $z, in: 0...50, step: 1)
            
            Text("Spheres:")
            Slider(value: $points, in: 100...10000, step: 100)
        }
    }
}
