import SwiftUI

struct ContentView: View {
    @State private var R: Double = 30  // Fixed circle radius
    @State private var r: Double = 10.0   // Moving circle radius
    @State private var d: Double = 5.0   // Distance from center
    
    var body: some View {
        GeometryReader { geometry in
            // Check aspect ratio to determine layout
            if geometry.size.width > geometry.size.height {
                // Landscape: Controls on the left
                HStack {
                    VStack(alignment: .leading) {
                        ControlView(R: $R, r: $r, d: $d)
                            .frame(maxWidth: geometry.size.width * 0.25) // Reserve 25% for controls
                            .padding()
                            .background(Color.gray.opacity(0.1))
                        Spacer() // Push content to the top
                    }
                    
                    SceneKitView(R: $R, r: $r, d: $d)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .border(Color.gray, width: 1)
                }
            } else {
                // Portrait: Controls at the bottom
                VStack {
                    SceneKitView(R: $R, r: $r, d: $d)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.8)
                        .border(Color.gray, width: 1)
                    
                    ControlView(R: $R, r: $r, d: $d)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
