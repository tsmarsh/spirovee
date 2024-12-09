import SwiftUI
import SpiroControls

struct ContentView: View {
    @State private var R: Double = 26
    @State private var r: Double = 10.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.5
    @State private var z: Double = 10
    @State private var num_points: Double = 10000.0

    @State private var showControls = true
    @State private var play = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
            
            VStack {
                // Main content
                SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points, play: $play)
                    .edgesIgnoringSafeArea(.all)
                
                // Control panel overlay
                if showControls {
                    // Customize the size of this panel as desired.
                    // For smaller screens, let it be quite large (like a fullscreen overlay).
                    // For larger screens, maybe make it narrower.
                    VStack() {
                        Text("Controls")
                            .font(.headline)
                        ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
            
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .transition(.move(edge: .leading)) // Animate in and out from the left
                }}.background(Color.black)
                // Button to toggle the controls overlay
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showControls.toggle()
                            }
                        }) {
                            Image(systemName: showControls ? "xmark" : "slider.horizontal.3")
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        Button(action: {
                            withAnimation {
                                play.toggle()
                            }
                        }) {
                            Image(systemName: play ? "stop" : "play")
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}
