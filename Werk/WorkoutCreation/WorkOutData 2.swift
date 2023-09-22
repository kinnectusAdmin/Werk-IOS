//
//  WorkOutData.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import Foundation
import SwiftUI



struct WorkoutBlueprint: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var warmup: WorkoutPhase
    var intervals: IntervalCollection
    var cooldown: WorkoutPhase
    var duration: Int {
        warmup.duration + cooldown.duration + intervals.duration
    }
}

extension WorkoutBlueprint {
    static func initial() -> WorkoutBlueprint {
        WorkoutBlueprint(
           id: UUID().uuidString
           ,name: ""
           , warmup: .warmUP
           , intervals: .initial
           , cooldown: .coolDown
       )
    }
}

extension WorkoutBlueprint: Equatable {
    static func ==(lhs:WorkoutBlueprint,rhs:WorkoutBlueprint) -> Bool {
        return lhs.id == rhs.id
    }
}

struct WorkoutBlock: Codable {
    var name: String
    var timeElapsed: Int
    var plannedDuration: Int
    var type: Intensity
}



struct WorkoutPhase: Identifiable, Hashable, Codable {
    let id: String
    var name: String
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var duration: Int {
        (hours * 3600) + (minutes * 60) + seconds
    }
}

extension WorkoutPhase  {
    static let coolDown = WorkoutPhase.init(id: UUID().uuidString, name: "Cool Down",  hours: 0, minutes: 0, seconds: 0)
    static let warmUP = WorkoutPhase(id: UUID().uuidString, name: "Warm Up", hours: 0, minutes: 0, seconds: 0)
    static let lowIntensity = WorkoutPhase(id: UUID().uuidString, name: "Low Intensity", hours: 0, minutes: 0, seconds: 0)
    static let highIntensity = WorkoutPhase(id: UUID().uuidString, name: "High Intensity", hours: 0, minutes: 0, seconds: 0)
    static let restBetweenPhases = WorkoutPhase(id: UUID().uuidString, name: "Rest", hours: 0, minutes: 0, seconds: 0)
}

struct IntervalCollection: Codable {
    var cycles: [Interval]
    var restBetweenPhases: WorkoutPhase
    var duration: Int {
        cycles.map { ($0.numberOfSets * $0.highIntensity.duration) + ($0.numberOfSets * $0.lowIntensity.duration)}.reduce(0, +) + (restBetweenPhases.duration * cycles.count)
    }
}

extension IntervalCollection {
    static let initial = IntervalCollection(cycles: [Interval.initial()], restBetweenPhases: .restBetweenPhases)
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
    static func initial() -> Interval {
        Interval.init(highIntensity: .highIntensity, lowIntensity: .lowIntensity, numberOfSets: 1, order: .startsWithHighIntensity)
    }
}



