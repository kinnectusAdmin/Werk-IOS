
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
    var workouts: [[WorkOutExercise]]
}

final class WorkoutHistoryViewModel: ObservableObject {
    
    var bars: [Bar] {
        myWorkOuts.map { workouts -> Bar in
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
    
    var myWorkOuts: [[WorkOutExercise]] {
       Date.weekOfDates(today: Date()).map { theDate -> (Int, Int) in
           let month: Int = Calendar.current.dateComponents([.month], from: theDate).month!
           let day: Int = Calendar.current.dateComponents([.day], from: theDate).day!
           let tuple = (month, day)
           return tuple
       }.map { tuple in
           [WorkOutExercise.randomWorkoutInRange(tuple, tuple)]
       }
    }
        
    
}

func dayStringFrom(date: Date) -> String {
    let day = Calendar.current.dateComponents([.weekday], from: date).weekday!
    let dayString = ["S","M","T","W","T","F","S"][day - 1]
    return dayString
}
func showCurrentWeekNumber(startDate: Date) -> Int {
    var calendar = Calendar.current
    calendar.firstWeekday =  1 // Monday
    calendar.locale = Locale.current
    
    
    let weekNumberForSatrtDate = calendar.component(.weekOfYear, from: startDate)
    
    
    
    return weekNumberForSatrtDate
}

func weekRangeOfYear(week: Int)->(Date, Date, String)  {
    
    var calendar = Calendar.current
    calendar.locale = Locale.current
    var weekStartComponents = DateComponents()
    weekStartComponents.weekOfYear = week
    weekStartComponents.weekday = 1
    weekStartComponents.year = calendar.component(.year, from: Date())
    
    var weekEndComponenets = DateComponents()
    weekEndComponenets.weekOfYear = week
    weekEndComponenets.weekday = 7  //days of the months go from 1 - 7
    weekEndComponenets.year = calendar.component(.year, from: Date())
    
    let weekStartDate = calendar.date(from: weekStartComponents)
    let weekEndDate = calendar.date(from: weekEndComponenets)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "LLL dd"
    let weekStarDayString = formatter.string(from: weekStartDate!)
    let weekEndDayString = formatter.string(from: weekEndDate!)
    print(weekStartDate)
    print(weekEndDate)
    
    return (weekStartDate!, weekEndDate!, "\(weekStarDayString) - \(weekEndDayString)")
}






// graph has to coencide with each week of the year and their individual days
// mus show colors of workout progressing vertically


