import SwiftUI
import SpiroControls

struct ContentView: View {
    @State private var R: Double = 26
    @State private var r: Double = 10.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.5
    @State private var z: Double = 10
    @State private var num_points: Double = 10000.0
    
    @State private var showControls = false
    @State private var play = false

    var body: some View {
        Group {
            if isCompactScreen() {
                // iPhone-like environment: Use a drawer or sheet for controls
                ZStack {
                    SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points, play: $play)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        HStack {
                            Button(action: { showControls.toggle() }) {
                                Image(systemName: showControls ? "xmark" : "slider.horizontal.3")
                                    .padding()
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            }
                            Button(action: { play.toggle() }) {
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
                .sheet(isPresented: $showControls) {
                    VStack {
                        Text("Controls").font(.headline).padding(.bottom, 8)
                        ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
                            .padding()
                        .padding(.top)
                    }
                    .presentationDetents([.medium, .large])
                }
            } else {
                // iPad/Mac environment: Use NavigationSplitView with a sidebar
                NavigationSplitView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Controls").font(.headline)
                        ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)

                        Button(action: { play.toggle() }) {
                            Image(systemName: play ? "stop" : "play")
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                        
                        Spacer()
                    }
                    .padding()
                } detail: {
                    SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points, play: $play)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
    
    private func isCompactScreen() -> Bool {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .phone
        #else
        return false
        #endif
    }
}
