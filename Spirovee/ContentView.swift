import SwiftUI
import SpiroControls

struct ContentView: View {
    @State private var R: Double = 26
    @State private var r: Double = 10.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.2
    @State private var z: Double = 10
    @State private var num_points: Double = 6000.0
    @State private var showSheet = false

    // A helper property to determine if we should show a sheet (for iPhone)
    // or use a sidebar layout (for iPad or Mac via Catalyst).
    var isCompactiOSDevice: Bool {
        #if os(iOS)
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .phone
        #else
        return false
        #endif
    }

    // Another helper for checking iPad or macOS via Catalyst
    var isLargeScreen: Bool {
        #if os(iOS)
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .pad || idiom == .mac
        #else
        // On macOS (non-catalyst), you’d always have a large screen
        return true
        #endif
    }

    var body: some View {
        Group {
            if isCompactiOSDevice {
                // iPhone-like environment: use a sheet
                ZStack {
                    SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showSheet.toggle()
                                }
                            }) {
                                Image(systemName: "slider.horizontal.3")
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
                .sheet(isPresented: $showSheet) {
                    VStack {
                        Text("Controls").font(.headline).padding(.bottom, 8)
                        ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
                            .padding()
                    }
                    .presentationDetents([.fraction(0.3), .medium, .large])
                }

            } else if isLargeScreen {
                // iPad or Mac Catalyst: use a sidebar
                NavigationSplitView {
                    // Sidebar
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Controls").font(.headline)
                        ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
                    }
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Text("Spirovee")
                                .font(.title)
                        }
                    }
                } detail: {
                    // Main content area
                    SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points)
                        .edgesIgnoringSafeArea(.all)
                }

            } else {
                // Fallback if needed, but ideally all cases are covered above
                SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
