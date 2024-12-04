import SwiftUI

struct ContentView: View {
    @State private var R: Double = 30
    @State private var r: Double = 10.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.2
    @State private var z: Double = 10
    @State private var num_points: Double = 10000.0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                // Header
                Text("Spirovee")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                    .padding(.top, 16)

                if geometry.size.width > geometry.size.height {
                    // Landscape Layout
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Spirograph Settings")
                                .font(.headline)
                                .padding(.bottom, 8)

                            ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                            Spacer()
                        }
                        .frame(maxWidth: geometry.size.width * 0.3)

                        SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .border(Color.gray, width: 1)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(12)
                    }
                } else {
                    // Portrait Layout
                    VStack(spacing: 16) {
                        SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.7)
                            .border(Color.gray, width: 1)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Spirograph Settings")
                                .font(.headline)
                                .padding(.bottom, 8)

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
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

#Preview {
    ContentView()
}
