
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
    
    
    
}
