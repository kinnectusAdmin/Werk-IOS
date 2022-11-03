//
//  WorkoutListManager.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/4/22.
//

import Foundation
import SwiftUI


struct WorkOutExercise: Identifiable, Hashable {
    var id: String = UUID().uuidString
    let name: String
    let duration: Double
    let date: Date
}

extension WorkOutExercise {
    
    static var randomWorkout: WorkOutExercise {
        var names: [String] {
            return ["Push Ups", "Sit Ups", "Pull Ups", "planks", "sprints", "LSits", "plankPulls"]
        }
        return WorkOutExercise(id: UUID().uuidString, name: names.randomElement()!, duration: Double.random(in: (1200...5400)), date: Date.randomDateThisYear())
        
        
    }
    static let randomWorkoutInRange: ((Int, Int), (Int, Int)) -> WorkOutExercise = { startRange, endRange in
        var names: [String] {
            return ["Push Ups", "Sit Ups", "Pull Ups", "planks", "sprints", "LSits", "plankPulls"]
        }
        return WorkOutExercise(id: UUID().uuidString, name: names.randomElement()!, duration: Double.random(in: (1200...5400)), date: Date.randomDateFrom(firstDate: startRange, secondDate: endRange))
        
        
    }
    func durationOfWorkout()->String {
        let x = duration
        var oneHour = 3600
        var numberOfHours = Int(x) / oneHour
        var minutesRemaining = Int(x) % oneHour
        var numberOfMinutes = minutesRemaining / 60
        var secondsRemaining = Int(x) % 60
        return "\(numberOfHours) hr \(numberOfMinutes) min\(secondsRemaining) secs"
    }
    
    func dailyWorkourDuration()-> Double {
        let x = duration
        var oneHour = 3600
        var oneMin = 60
        var oneSec = 1

        
        return 0.0
    }

}

//WORKOUT DATA ^

class WorkoutListViewModel: ObservableObject {
    var workOuts: [WorkOutExercise]
    init(workOuts: [WorkOutExercise]) {
        self.workOuts = workOuts
    }
}

extension WorkoutListViewModel {
    func didSelectWorkout(workout:WorkOutExercise) {
        
    }
    
    func didSelectAddWorkout(){
        
    }
    
}


extension Date {
    static func randomDateThisYear() -> Date {
        var dateComponent = DateComponents()
        dateComponent.calendar = Calendar.current
        dateComponent.month = 1
        dateComponent.day = 1
        dateComponent.year = Calendar.current.component(.year, from: Date())
        
        
        var enddateComponent = DateComponents()
        enddateComponent.calendar = Calendar.current
        enddateComponent.month = 12
        enddateComponent.day = 31
        enddateComponent.year = Calendar.current.component(.year, from: Date())
        
        guard let startDate = dateComponent.date, let endDate = enddateComponent.date else { return Date() }
        
        return random(in: (startDate..<endDate))
    }
    
    static func randomDateFrom(firstDate:(Int,Int), secondDate:(Int, Int))-> Date {
        var startDateComponents = DateComponents()
        startDateComponents.month = firstDate.0
        startDateComponents.day = firstDate.1
        startDateComponents.year = Calendar.current.component(.year, from:Date())
        
        var endDateComponents = DateComponents()
        endDateComponents.month = secondDate.0
        endDateComponents.day = secondDate.1
        endDateComponents.year = Calendar.current.component(.year, from:Date())
        
        guard let startDate = Calendar.current.date(from: startDateComponents),
                let endDate = Calendar.current.date(from: endDateComponents) else { return Date() }
        
        
        return random(in:startDate..<endDate)
        
    }
    
    
    static func random(in range: Range<Date>) -> Date {
        let startInterval = range.lowerBound.timeIntervalSince1970
        let endInterval = range.upperBound.timeIntervalSince1970
        let timestamp = (Int(startInterval)...Int(endInterval)).map { $0 }.randomElement() ?? 0
        return Date(timeIntervalSince1970: Double(timestamp))
    }
}
