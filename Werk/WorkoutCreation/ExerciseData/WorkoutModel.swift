//
//  WorkoutModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/12/22.
//



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

struct WorkoutTemplate: Identifiable, Hashable {
    var id: String = UUID().uuidString
    let name: String
    let duration: Double
    let date: Date
}

public func durationOfWorkout(duration: Double)->String {
    let x = duration
    let oneHour = 3600
    let numberOfHours = Int(x) / oneHour
    let minutesRemaining = Int(x) % oneHour
    let numberOfMinutes = minutesRemaining / 60
    let secondsRemaining = Int(x) % 60
    return "\(numberOfHours):\(numberOfMinutes):\(secondsRemaining)"
}

extension WorkoutTemplate {
    
    static var randomWorkout: WorkoutTemplate {
        var names: [String] {
            return ["Push Ups", "Sit Ups", "Pull Ups", "planks", "sprints", "LSits", "plankPulls"]
        }
        return WorkoutTemplate(id: UUID().uuidString, name: names.randomElement()!, duration: Double.random(in: (1200...5400)), date: Date.randomDateThisYear())
        
        
    }
    static let randomWorkoutInRange: ((Int, Int), (Int, Int)) -> WorkoutTemplate = { startRange, endRange in
        var names: [String] {
            return ["Push Ups", "Sit Ups", "Pull Ups", "planks", "sprints", "LSits", "plankPulls"]
        }
        return WorkoutTemplate(id: UUID().uuidString, name: names.randomElement()!, duration: Double.random(in: (1200...5400)), date: Date.randomDateFrom(firstDate: startRange, secondDate: endRange))
        
        
    }
    
    
    func dailyWorkourDuration()-> Double {
        let x = duration
        var oneHour = 3600
        var oneMin = 60
        var oneSec = 1
        
        
        return 0.0
    }
    
}


import Foundation
