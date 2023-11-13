
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
        service.observeRecordedWorkouts().assign(to: &$allWorkouts)
        $weekSelection.map{ [weak self] selectedWeek -> [Bar] in
            guard let self = self else { return [] }
            let weekOfDates = Date.weekOfDates(weekOfYear: selectedWeek)
            return weekOfDates.map { date -> Bar in
                let daysWorkouts = self.allWorkouts.filter{
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
        let height = (duration / maxDuration) * 100
        print("maxDuration: ", maxDuration)
        print("height: ", height)
        return height
    }
}
