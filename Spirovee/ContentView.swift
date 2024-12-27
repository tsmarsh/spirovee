import SwiftUI
import SpiroControls

public struct ViewState: Identifiable {
    public let id: UUID = UUID()
    
    public var R: Double = 26
    public var r: Double = 10.0
    public var d: Double = 5.0
    public var t: Double = 0.5
    public var z: Double = 10
    public var num_points: Double = 10000.0
}

struct ContentView: View {
    @State private var spiros: [ViewState] = [
        // Just give some example defaults
        .init(R: 10, r: 5, d: 3, t: 0.5, z: 0, num_points: 500),
        .init(R: 20, r: 10, d: 5, t: 0.2, z: 0, num_points: 1000),
        .init(R: 15, r: 12, d: 6, t: 0.25, z: 0, num_points: 2500)
    ]
    @State private var showControls = false
    @State private var play = false

    var body: some View {
        Group {
            if isCompactScreen() {
                // iPhone-like environment: Use a drawer or sheet for controls
                ZStack {
                    SpiroveeScene(state: $spiros[0], play: $play)
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
                        MultipleSpirographsView(spiros: $spiros)
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
                        MultipleSpirographsView(spiros: $spiros)
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
                    SpiroveeScene(state: $spiros[0], play: $play)
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

public struct MultipleSpirographsView: View {
    @Binding public var spiros: [ViewState]

    public var body: some View {
        NavigationStack {
            List {
                // Convert spiros into an Array of (index, Binding<ViewState>) pairs
                ForEach(Array($spiros.enumerated()), id: \.1.id) { (index, $spiro) in
                    Section(header: Text("Spiro #\(index + 1)")) {
                        ControlView(
                            R: $spiro.R,
                            r: $spiro.r,
                            d: $spiro.d,
                            t: $spiro.t,
                            z: $spiro.z,
                            points: $spiro.num_points
                        )
                    }
                }
                // 1) Enable swipe-to-delete
                .onDelete(perform: deleteSpiro)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Multiple Spirographs")
            // 2) Add a toolbar with Edit and Add buttons
            .toolbar {
                EditButton()  // Toggles swipe-to-delete mode
                Button(action: addSpiro) {
                    Label("Add Spiro", systemImage: "plus")
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func addSpiro() {
        // Append a new Spiro with default parameters (customize as desired)
        spiros.append(ViewState())
    }
    
    private func deleteSpiro(at offsets: IndexSet) {
        spiros.remove(atOffsets: offsets)
    }
}

