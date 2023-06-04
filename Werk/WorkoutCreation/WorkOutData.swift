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


struct WorkoutBlock {
    let name: String
    var timeElapsed: Int
    let plannedDuration: Int
    let type: Intensity
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
    var duration: Int {
        cycles.map { ($0.numberOfSets * $0.highIntensity.duration) + ($0.numberOfSets * $0.lowIntensity.duration)}.reduce(0, +) + (restBetweenPhases.duration * cycles.count)
    }
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
    var duration: Int {
        warmup.duration + cooldown.duration + intervals.duration
    }
    
}

extension WorkoutBlueprint {
    static var initial = WorkoutBlueprint(
        id: ""
        ,name: ""
        , warmup: .warmUP
        , intervals: .initial
        , cooldown: .coolDown
    )
}
extension WorkoutBlueprint: Equatable {
    static func ==(lhs:WorkoutBlueprint,rhs:WorkoutBlueprint) -> Bool {
        return lhs.id == rhs.id
    }
}

