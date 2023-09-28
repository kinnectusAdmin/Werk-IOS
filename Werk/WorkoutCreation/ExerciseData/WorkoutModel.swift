//
//  WorkoutModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/12/22.
//


import Foundation
import SwiftUI

//var workoutDateComponenet: [[WorkoutBlueprint]] {
//    Date.weekOfDates(today: Date()).map { theDate -> (Int, Int) in
//        let month: Int = Calendar.current.dateComponents([.month], from: theDate).month!
//        let day: Int = Calendar.current.dateComponents([.day], from: theDate).day!
//        let tuple = (month, day)
//        return tuple
//    }.map { tuple in
//        [WorkoutBlueprint.randomWorkoutInRange(tuple, tuple)]
//    }
//}

public func durationOfWorkout(duration: Double)->String {
    let x = duration
    let oneHour = 3600
    let numberOfHours = Int(x) / oneHour
    let minutesRemaining = Int(x) % oneHour
    let numberOfMinutes = minutesRemaining / 60
    let secondsRemaining = Int(x) % 60
    let hoursRepresentation = numberOfHours > 9 ? "\(numberOfHours)" : "0\(numberOfHours)"
    let minutesRepresentation = numberOfMinutes > 9 ? "\(numberOfMinutes)" : "0\(numberOfMinutes)"
    let secondsRepresentation = secondsRemaining > 9 ? "\(secondsRemaining)" : "0\(secondsRemaining)"
    return "\(hoursRepresentation):\(minutesRepresentation):\(secondsRepresentation)"
}
struct RecordedWorkout: Identifiable, Codable {
    var userId: String 
    var id: String = UUID().uuidString
    let name: String
    var duration: Double
    let date: Date
    
    //change name to workout record
    
    
    
    
    
    func dailyWorkourDuration()-> Double {
        let x = duration
        var oneHour = 3600
        var oneMin = 60
        var oneSec = 1
        
        
        return 0.0
    }
    
}

extension RecordedWorkout: Equatable {
    static func ==(lhs:RecordedWorkout,rhs:RecordedWorkout) -> Bool {
        return lhs.id == rhs.id
    }
}
