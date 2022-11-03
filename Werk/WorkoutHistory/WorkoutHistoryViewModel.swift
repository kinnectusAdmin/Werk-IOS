
import Foundation
import SwiftUI
import HealthKit

final class WorkoutHistoryViewModel: ObservableObject {
    
    struct Works {
        var myWorkOuts: [WorkOutExercise] = [
            WorkOutExercise.randomWorkoutInRange((10,24),(10,24)),
            WorkOutExercise.randomWorkoutInRange((10,24),(10,24)),
            WorkOutExercise.randomWorkoutInRange((10,24),(10,24)),
            
            WorkOutExercise.randomWorkoutInRange((10,25),(10,25)),
            WorkOutExercise.randomWorkoutInRange((10,25),(10,25)),
            WorkOutExercise.randomWorkoutInRange((10,25),(10,25)),
            WorkOutExercise.randomWorkoutInRange((10,25),(10,25)),
            
            WorkOutExercise.randomWorkoutInRange((10,26),(10,26)),
            WorkOutExercise.randomWorkoutInRange((10,26),(10,26)),
            WorkOutExercise.randomWorkoutInRange((10,26),(10,26)),
            WorkOutExercise.randomWorkoutInRange((10,26),(10,26)),
            WorkOutExercise.randomWorkoutInRange((10,26),(10,26)),
            
            WorkOutExercise.randomWorkoutInRange((10,27),(10,27)),
            WorkOutExercise.randomWorkoutInRange((10,27),(10,27)),
            WorkOutExercise.randomWorkoutInRange((10,27),(10,27)),
            WorkOutExercise.randomWorkoutInRange((10,27),(10,27)),
            WorkOutExercise.randomWorkoutInRange((10,27),(10,27)),
            WorkOutExercise.randomWorkoutInRange((10,27),(10,27)),
            
            WorkOutExercise.randomWorkoutInRange((10,28),(10,28)),
            WorkOutExercise.randomWorkoutInRange((10,28),(10,28)),
            WorkOutExercise.randomWorkoutInRange((10,28),(10,28)),
            WorkOutExercise.randomWorkoutInRange((10,28),(10,28)),
            
            WorkOutExercise.randomWorkoutInRange((10,29),(10,29)),
            WorkOutExercise.randomWorkoutInRange((10,29),(10,29)),
            WorkOutExercise.randomWorkoutInRange((10,29),(10,29))
            
            //    (0...30).map { _ -> WorkOutExercise in
            //              WorkOutExercise.randomWorkoutInRange((10,16),(10,22))
            //
            //              //make bars from the workouts
            //          }
        ]
    }
    
    
    struct Bar: Identifiable {
        
        let id = UUID().uuidString
        var name: String
        var day: String
        var value:
        var color: Color
        
        static var weeklyStats: [Bar] {
            var dailyBars = [Bar]()
            var color: Color = .orange
            let days = ["S","M","T","W","T","F","S"]
            
            for i in 1...7 {
                let stats = Double.random(in: 20...200.0)
                let bar = Bar(name: "\(i)",day: days[i-1], value: stats, color: color)
                dailyBars.append(bar)
            }
            return dailyBars
        }
    }
    
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


