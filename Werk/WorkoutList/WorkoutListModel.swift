//
//  WorkoutListManager.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/4/22.
//

import Foundation


class WorkoutListModel {
    
    struct WorkOutExercise: Hashable {
        let id: String
        let name: String
        let duration: Double
        static var randomWorkout: WorkOutExercise {
            var names: [String] {
                return ["Push Ups", "Sit Ups", "Pull Ups", "planks", "sprints", "LSits", "plankPulls"]
            }
            return WorkOutExercise(id: UUID().uuidString, name: names.randomElement()!, duration: Double.random(in: (1200...5400)))
            
        
    }
    
//    extension WorkOutExercise {
//        CANT BE NESTED
//        }
        
        func durationOfWorkout()->String {
            let x = duration
            var oneHour = 3600
            var numberOfHours = Int(x) / oneHour
            var minutesRemaining = Int(x) % oneHour
            var numberOfMinutes = minutesRemaining / 60
            var secondsRemaining = Int(x) % 60
            return "\(numberOfHours) hr \(numberOfMinutes) min\(secondsRemaining) secs"
        }
        
    }
}

