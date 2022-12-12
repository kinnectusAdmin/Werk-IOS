
import Foundation
import SwiftUI


extension CGFloat {
    static var randomHex: CGFloat {
        CGFloat.random(in: (0..<2))
    }
}

extension UIColor {
    static var random: UIColor {
        UIColor(red: CGFloat.randomHex,
                green: CGFloat.randomHex,
                blue: CGFloat.randomHex,
                alpha: 1.0)
    }
}

struct Bar: Identifiable {
    
    let id = UUID().uuidString
    var name: String
    var day: String
    var value: [Double]
    var color: [Color] {
        value.map { _  -> Color in
            let color = UIColor.random
            return Color(uiColor: color)
        }
    }
    var totalDuration: CGFloat {
        CGFloat(value.reduce(0, +))
    }
    var workouts: [[WorkoutTemplate]]
}

final class WorkoutHistoryViewModel: ObservableObject {
    
    @State var weekSelection: Int = showCurrentWeekNumber(startDate: Date())
    
    var bars: [Bar] {
        WorkoutDateComponenet.map { workouts -> Bar in
            Bar(name: "",
                day: dayStringFrom(date:workouts.first!.date),
                value: workouts.map { $0.duration },
                workouts: [])
        }
    }
    var maxDuration: CGFloat {
        bars.map { $0.totalDuration }.max() ?? 0
    }
    
    func relativeDuration(duration: CGFloat) -> CGFloat {
        (duration / maxDuration) * 100
    }
}
// graph has to coencide with each week of the year and their individual days
// mus show colors of workout progressing vertically


