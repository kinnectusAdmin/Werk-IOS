import SwiftUI

struct Bar: Identifiable {

    let id = UUID()
    var name: String
    var day: String
    var value: Double
    var color: Color
    
    static var sampleBars: [Bar] {
        var dailyBars = [Bar]()
        var color: Color = .blue
        let days = ["S","M","T","W","T","F","S"]
        
        for i in 1...7 {
            let rand = Double.random(in: 20...200.0)
            let bar = Bar(name: "\(i)",day: days[i-1], value: rand, color: color)
            dailyBars.append(bar)
        }
        return dailyBars
    }
}

struct BarChat: View {
    @State private var bars = Bar.sampleBars
    @State private var selectedID: UUID = UUID()
    @State private var text = "Workout History"
    
    var body: some View {
        VStack {
            Text(text)
                .bold()
                .padding()
            
            HStack(alignment: .bottom, spacing: 20) {
                ForEach(bars) { bar in
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(bar.color)
                                .frame(width: 35, height: bar.value, alignment: .bottom)
                                
                                .opacity(selectedID == bar.id ? 0.5 : 1.0)
                                .cornerRadius(90)
                                .onTapGesture {
                                    self.selectedID = bar.id

                                }
                        }
                        Text(bar.day)
                    }
                    
                }
            }
            .frame(height:240, alignment: .bottom)
            .padding(20)
            .cornerRadius(6)

        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChat()
    }
}
