
import Foundation
import SwiftUI
import Combine

//

final class WorkoutHistoryViewModel: ObservableObject {
    private var weekSelection: Int = showCurrentWeekNumber(startDate: Date())
    @Published var bars: [Bar] = []
    private let service: DataStorageServiceIdentity!
    @Published var allWorkouts: [RecordedWorkout] = []
    private var cancellables = Set<AnyCancellable>()
    var weekSelectionBinding: Binding<Int> {
        .init { [weak self] in
            self?.weekSelection ?? 0
        } set: { [weak self] newWeek in
            self?.weekSelection = newWeek
            self?.setWeekWorkouts(newWeek)
        }

    }
    private func setWeekWorkouts(_ selectedWeek: Int) {
        let weekOfDates = Date.weekOfDates(weekOfYear: selectedWeek)
        let weekWorkouts = weekOfDates.map { date -> Bar in
            let daysWorkouts = allWorkouts.filter{
                $0.date.isSameDay(date)
            }
            return Bar(day: dayStringFrom(date: date),
                       value: daysWorkouts.map(\.duration))
        }
        bars = weekWorkouts
    }
    init(service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        service.observeRecordedWorkouts().assign(to: &$allWorkouts)
//        let localRecordedWorkouts = [RecordedWorkout]()//service.getRecordedWorkouts()
//        $weekSelection.map{ [weak self] selectedWeek -> [Bar] in
//            guard let self = self else { return [] }
//            let weekOfDates = Date.weekOfDates(weekOfYear: selectedWeek)
//            return weekOfDates.map { date -> Bar in
//                let daysWorkouts = localRecordedWorkouts.filter{
//                    $0.date.isSameDay(date)
//                }
//                return Bar(day: dayStringFrom(date: date),
//                           value: daysWorkouts.map(\.duration)) 
//            }
//            []
//        }.assign(to: &$bars)
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
