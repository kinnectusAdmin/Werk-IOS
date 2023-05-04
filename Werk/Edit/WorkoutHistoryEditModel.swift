
import Foundation
import SwiftUI

final class WorkoutHistoryEditModel: ObservableObject {
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
            return workouts.filter { workout in
                let month = Calendar.current.component(.month, from: workout.date)
                let day = Calendar.current.component(.day, from: workout.date)
                return  month == tuple.0 && day == tuple.1
                
            }
        }
    }
    
    var maxDuration: CGFloat {
        bars.map { $0.totalDuration }.max() ?? 0
    }
    
    private let service: DataStorageServiceIdentity
    private let workouts: [Workout]
    
    init(service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        self.workouts = [service.getWorkout()].compactMap { $0 }
    }
    func relativeDuration(duration: CGFloat) -> CGFloat {
        (duration / maxDuration) * 100
    }
}


