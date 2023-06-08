//
//  WorkOutData.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import Foundation
import SwiftUI


enum Sound: Int, Codable {
    case ding = 1309
    case dingding = 1304
}



struct WorkoutPhase: Identifiable, Hashable, Codable {
    let id: String
    var name: String
    var color: Int
    var sound: Sound
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var duration: Int {
        hours + minutes + seconds
    }
}

extension WorkoutPhase {
    static var coolDown = WorkoutPhase.init(id: UUID().uuidString, name: "Cool Down",  color: 0, sound: .ding,  hours: 0, minutes: 0, seconds: 0)
    static let warmUP = WorkoutPhase(id: UUID().uuidString, name: "Warm Up", color: 0 , sound: .dingding, hours: 0, minutes: 0, seconds: 0)
    static let lowIntensitiy = WorkoutPhase(id: UUID().uuidString, name: "Low Intentsity", color: 0 , sound: .ding, hours: 0, minutes: 0, seconds: 10)
    static let highItensitity = WorkoutPhase(id: UUID().uuidString, name: "High Intensitiy", color: 0 , sound: .dingding, hours: 0, minutes: 0, seconds: 20)
    static let rest = WorkoutPhase(id: UUID().uuidString, name: "Rest Between Cycles", color: 0, sound: .dingding, hours: 0, minutes: 0, seconds: 0)
}

struct IntervalCollection: Codable {
    var cycles: [Interval]
    var restBetweenPhases: WorkoutPhase
}

extension IntervalCollection {
    static let initial = IntervalCollection(cycles: [.initial], restBetweenPhases: .rest)
}

struct Interval: Identifiable, Codable {
    enum Order: Codable {
        case startsWithHighIntensity
        case startsWithLowIntensity
    }
    var id: String = UUID().uuidString
    var highIntensity: WorkoutPhase
    var lowIntensity: WorkoutPhase
    var numberOfSets: Int
    var order: Order
}

extension Interval {
    static let initial = Interval.init(highIntensity: .highItensitity, lowIntensity: .lowIntensitiy, numberOfSets: 1, order: .startsWithHighIntensity)
}


// v rename to workout plan/blue print
struct WorkoutBlueprint: Codable {
    var id: String = UUID().uuidString
    var name: String
    var warmup: WorkoutPhase
    var intervals: IntervalCollection
    var cooldown: WorkoutPhase
    var highIntensity: WorkoutPhase
    var lowIntensity: WorkoutPhase
    var duration: Int {
        return
        warmup.duration + cooldown.duration + highIntensity.duration + lowIntensity.duration
    }
    
}

extension WorkoutBlueprint {
    static var initial = WorkoutBlueprint(
        id: ""
        ,name: ""
        , warmup: .warmUP
        , intervals: .initial
        , cooldown: .coolDown
        , highIntensity: .highItensitity
        , lowIntensity: .lowIntensitiy
    )
}
extension WorkoutBlueprint: Equatable {
    static func ==(lhs:WorkoutBlueprint,rhs:WorkoutBlueprint) -> Bool {
        return lhs.id == rhs.id
    }
}
//extension WorkoutBlueprint {
//
//    static var randomWorkout: WorkoutBlueprint {
//        var names: [String] {
//            return ["Push Ups", "Sit Ups", "Pull Ups", "planks", "sprints", "LSits", "plankPulls"]
//        }
//        return WorkoutBlueprint.initial
//
//
//    }
//    static let randomWorkoutInRange: ((Int, Int), (Int, Int)) -> WorkoutBlueprint = { startRange, endRange in
//        var names: [String] {
//            return ["Push Ups", "Sit Ups", "Pull Ups", "planks", "sprints", "LSits", "plankPulls"]
//        }
//        return WorkoutBlueprint.initial
//
//
//    }
//
//
//
//    //MOVE ALL OF THIS
//    //FIRE BASE
//    //
//}
