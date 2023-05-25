
import Foundation
import SwiftUI
import Combine

final class WorkoutHistoryViewModel: ObservableObject {
    @Published var weekSelection: Int = showCurrentWeekNumber(startDate: Date())
    @Published var bars: [Bar] = []
    private let service: DataStorageServiceIdentity!
    private var allWorkouts: [RecordedWorkout] = []
    private var cancellables = Set<AnyCancellable>()
    init(service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        self.allWorkouts = service.getRecordedWorkouts()
        
        
        $weekSelection.map{ selectedWeek -> [Bar] in
            Date.weekOfDates(weekOfYear: selectedWeek).map { date -> Bar in
                let daysWorkouts = service.getRecordedWorkouts().filter{
                    $0.date.isSameDay(date)
                }
                return Bar(day: dayStringFrom(date: date),
                           value: daysWorkouts.map(\.duration))
            }
        }.assign(to: &$bars)
    }
    
    
    var maxDuration: CGFloat {
        bars.map { $0.totalDuration }.max() ?? 0
    }
    
    func relativeDuration(duration: CGFloat) -> CGFloat {
        (duration / maxDuration) * 100
    }
    
    
    
    //    var bars: [Bar] {
    //        service.getRecordedWorkouts.map { recordedWorkouts -> Bar in
    //            Bar(name: "",
    //                day: dayStringFrom(date: recordedWorkouts.1),
    //                value: recordedWorkouts.0.map { Double($0.duration) },
    //                recordedWorkouts: [recordedWorkouts.0.map { RecordedWorkout(name: $0.name, duration: Double($0.duration), date: $0.date)}])
    //        }
    //    }
    
    
    
    
    
    
    //    var workoutDateComponent: [([RecordedWorkout], Date)] {
    //        Date.weekOfDates(today: Date()).map { theDate -> (Int, Int, Date) in
    //            let month: Int  = Calendar.current.dateComponents([.month], from: theDate).month!
    //            let day: Int    =  Calendar.current.dateComponents([.day], from: theDate).day!
    //            let tuple       = (month, day, theDate)
    //            return tuple
    //        }.map { tuple in
    //            return (recordedWorkouts.filter { recordedWorkout in
    //                let month = Calendar.current.component(.month, from: recordedWorkout)
    //                let day = Calendar.current.component(.day, from: recordedWorkout.date)
    //                return  month == tuple.0 && day == tuple.1
    //
    //            }, tuple.2)
    //        }
    //    }
}


//    var bars: [Bar] {
//        workoutDateComponent.map { workouts -> Bar in
//            let recordedWorkouts = workouts.0.map { RecordedWorkout(name: $0.name, duration: Double($0.duration), date: $0.date) }
//            return Bar(name: "",
//                day:        dayStringFrom(date: workouts.1),
//                value:      workouts.0.map { Double($0.duration) },
//                workouts:   [recordedWorkouts])
//        }
//    }
