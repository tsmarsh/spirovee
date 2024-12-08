import SwiftUI
import SpiroControls

struct ContentView: View {
    @State private var showSheet: Bool = false
    @State private var R: Double = 26
    @State private var r: Double = 10.0
    @State private var d: Double = 5.0
    @State private var t: Double = 0.2
    @State private var z: Double = 10
    @State private var num_points: Double = 6000.0

    var body: some View {
        ZStack {
            SpiroveeScene(R: $R, r: $r, d: $d, t: $t, z: $z, desiredPoints: $num_points).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        withAnimation{
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
        }.sheet(isPresented: $showSheet){
            VStack{
                ControlView(R: $R, r: $r, d: $d, t: $t, z: $z, points: $num_points).padding()
            }.presentationDetents([.fraction(0.3), .medium, .large])
        }
    }
}
