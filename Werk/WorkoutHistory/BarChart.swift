import SwiftUI
import Charts

struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct WorkoutBarChart_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutBarChart(workoutData: [30, 45, 60, 20, 50, 40, 55])
            .previewLayout(.fixed(width: 400, height: 300))
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(
            data: [30, 45, 60, 20, 50, 40, 55],
            title: "Workout Duration",
            legend: "Days of the Week",
            labels: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        )
        .previewLayout(.fixed(width: 400, height: 300))
    }
}

struct BarsView_Previews: PreviewProvider {
    static var previews: some View {
        BarsView(data: [30, 45, 60, 20, 50, 40, 55])
            .previewLayout(.fixed(width: 400, height: 200))
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 0.5, color: .blue)
            .previewLayout(.fixed(width: 50, height: 200))
    }
}

struct WorkoutBarChart: View {
    let workoutData: [Double]
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack {
            BarChartView(
                data: workoutData,
                title: "Workout Duration",
                legend: "Days of the Week",
                labels: daysOfWeek
            )
            .frame(height: 300)
            .padding()
        }
    }
}

struct BarChartView: View {
    let data: [Double]
    let title: String
    let legend: String
    let labels: [String]

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Spacer()
            BarsView(data: data)
            Spacer()
            HStack {
                ForEach(0..<labels.count) { index in
                    Text(self.labels[index])
                        .frame(maxWidth: .infinity)
                }
            }
            Text(legend)
                .font(.caption)
        }
    }
}

struct BarsView: View {
    let data: [Double]

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(self.data.indices, id: \.self) { index in
                    BarView(value: self.normalizedValue(index), color: .blue)
                        .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height * CGFloat(self.data[index]))
                }
            }
        }
    }

    func normalizedValue(_ index: Int) -> CGFloat {
        let maxDataValue = data.max() ?? 1.0
        return CGFloat(data[index] / maxDataValue)
    }
}

struct BarView: View {
    let value: CGFloat
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(maxWidth: .infinity, maxHeight: value)
    }
}

struct ContentView: View {
    let workoutData: [Double] = [30, 45, 60, 20, 50, 40, 55] // Sample workout durations

    var body: some View {
        WorkoutBarChart(workoutData: workoutData)
    }
}
