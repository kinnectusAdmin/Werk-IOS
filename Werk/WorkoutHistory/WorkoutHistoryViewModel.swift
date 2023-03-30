
import Foundation
import SwiftUI
//



final class WorkoutHistoryViewModel: ObservableObject {
    
    @Published var weekSelection: Int = showCurrentWeekNumber(startDate: Date())
    var bars: [Bar] {
        workoutDateComponenet.map { workouts -> Bar in
            Bar(name: "",
                day: dayStringFrom(date:workouts.first!.date),
                value: workouts.map { $0.duration },
                workouts: [])
        }
    }


    var workoutDateComponenet: [[WorkoutTemplate]] {
        Date.weekOfDates(today: Date()).map { theDate -> (Int, Int) in
            let month: Int = Calendar.current.dateComponents([.month], from: theDate).month!
            let day: Int = Calendar.current.dateComponents([.day], from: theDate).day!
            let tuple = (month, day)
            return tuple
        }.map { tuple in
            [WorkoutTemplate.randomWorkoutInRange(tuple, tuple)]
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


