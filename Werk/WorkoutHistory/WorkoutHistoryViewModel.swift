
import Foundation
import SwiftUI

final class WorkoutHistoryViewModel: ObservableObject {
    @Published var weekSelection: Int = showCurrentWeekNumber(startDate: Date())
    
    var bars: [Bar] {
        workoutDateComponent.map { workouts -> Bar in
            Bar(name: "",
                day: dayStringFrom(date:workouts.first!.date),
                value: workouts.map { Double($0.duration) },
                workouts: [])
        }
    }
    
    
    var workoutDateComponent: [[Workout]] {
        Date.weekOfDates(today: Date()).map { theDate -> (Int, Int) in
            let month: Int = Calendar.current.dateComponents([.month], from: theDate).month!
            let day: Int = Calendar.current.dateComponents([.day], from: theDate).day!
            let tuple = (month, day)
            return tuple
        }.map { tuple in
            [Workout.randomWorkoutInRange(tuple, tuple)]
        }
    }
    
    var maxDuration: CGFloat {
        bars.map { $0.totalDuration }.max() ?? 0
    }
    
    func relativeDuration(duration: CGFloat) -> CGFloat {
        (duration / maxDuration) * 100
    }
}


