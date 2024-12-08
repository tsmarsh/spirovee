import SwiftUI
import SpiroControls

struct ContentView: View {
    @State private var R: Double = 26
    @State private var r: Double = 10.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.2
    @State private var z: Double = 10
    @State private var num_points: Double = 6000.0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                if geometry.size.width > geometry.size.height {
                    // Landscape Layout
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 16) {
                            Spacer(minLength: 16)
                            ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                            Spacer()
                        }
                        .frame(maxWidth: geometry.size.width * 0.3)
                    
                    
                        SpiroveeScene(
                            R: $R,
                            r: $r,
                            d: $d,
                            t: $t,
                            z: $z,
                            desiredPoints: $num_points
                        )
                        .edgesIgnoringSafeArea(.all)
                    }
                } else {
                    // Portrait Layout
                    VStack(spacing: 16) {
                        SpiroveeKit(
                            R: $R,
                            r: $r,
                            d: $d,
                            t: $t,
                            z: $z,
                            desiredPoints: $num_points
                        )
                        .edgesIgnoringSafeArea(.all)

                        VStack(alignment: .leading, spacing: 16) {
                            ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .background(Color(UIColor.black))
        }
    }
}

#Preview {
    ContentView()
}
