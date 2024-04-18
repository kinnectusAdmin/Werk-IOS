
import Foundation
import SwiftUI
import Combine

//

final class WorkoutHistoryViewModel: ObservableObject {
    @Published var weekSelection: Int = showCurrentWeekNumber(startDate: Date())
    @Published var bars: [Bar] = []
    private let service: DataStorageServiceIdentity!
    @Published var allWorkouts: [RecordedWorkout] = []
    private var cancellables = Set<AnyCancellable>()
   
    init(service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        service.getRecordedWorkoutsRemote()
        service.observeRecordedWorkouts().assign(to: &$allWorkouts) 
        
                $weekSelection.map{ [weak self] selectedWeek -> [Bar] in
                    guard let self = self else { return [] }
                    let weekOfDates = Date.datesForWeek(weekOfYear: selectedWeek)
                    return weekOfDates.map { date -> Bar in  // 2.) could be here
                        let daysWorkouts = self.allWorkouts.filter{
                            $0.date.isSameDay(date)
                        }
                        return Bar(day: dayStringFrom(date: date),
                                   value: daysWorkouts.map(\.duration))  //or here
        
                    }
                }.assign(to: &$bars)
//        func makeBars() -> [Bar] {
//            let weekOfDates = Date.weekOfDates(weekOfYear: showCurrentWeekNumber(startDate: Date()))
//            return weekOfDates.map { date -> Bar in  // 2.) could be here
//                let daysWorkouts = self.allWorkouts.filter{
//                    $0.date.isSameDay(date)
//                }
//                return Bar(day: dayStringFrom(date: date),
//                           value: daysWorkouts.map(\.duration))  //or here
//
//            }
//        }
//        self.bars = makeBars()
        print(self.bars)

    }
    
    var maxDuration: CGFloat {
        bars.map { $0.totalDuration }.max() ?? 0
    }
    
    func relativeDuration(duration: CGFloat) -> CGFloat {
        let height = (duration / maxDuration) * 100
        print("maxDuration: ", maxDuration)
        print("height: ", height)
        return height
    }
}
