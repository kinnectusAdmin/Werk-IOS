//
//  WorkOutData.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import Foundation
import SwiftUI


enum Sound: Int {
    case ding = 1309
    case dingding = 1304
}

struct WorkoutPhase: Identifiable, Hashable {
    let id: String
    var name: String
    var color: Color
    var sound: Sound
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var duration: Int {
        hours + minutes + seconds
    }
}

extension WorkoutPhase {
    static var coolDown = WorkoutPhase.init(id: UUID().uuidString, name: "Cool Down",  color: .blue, sound: .ding,  hours: 0, minutes: 0, seconds: 0)
    static let warmUP = WorkoutPhase(id: UUID().uuidString, name: "Warm Up", color: .yellow, sound: .dingding, hours: 0, minutes: 0, seconds: 0)
    static let lowIntensitiy = WorkoutPhase(id: UUID().uuidString, name: "Low Intentsity", color: .cyan, sound: .ding, hours: 0, minutes: 0, seconds: 10)
    static let highItensitity = WorkoutPhase(id: UUID().uuidString, name: "High Intensitiy", color: .red, sound: .dingding, hours: 0, minutes: 0, seconds: 20)
    static let rest = WorkoutPhase(id: UUID().uuidString, name: "Rest Between Cycles", color: .indigo, sound: .dingding, hours: 0, minutes: 0, seconds: 0)
}

struct IntervalCollection {
    var cycles: [Interval]
    var restBetweenPhases: WorkoutPhase
}

extension IntervalCollection {
    static let initial = IntervalCollection(cycles: [.initial], restBetweenPhases: .rest)
}

struct Interval: Identifiable {
    enum Order {
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

struct Workout {
    var warmup: WorkoutPhase
    var intervals: IntervalCollection
    var cooldown: WorkoutPhase
    var highIntensity: WorkoutPhase
    var lowIntensity: WorkoutPhase
    
}

extension Workout {
    static var initial = Workout(warmup: .warmUP
                                 , intervals: .initial
                                 , cooldown: .coolDown
                                 , highIntensity: .highItensitity
                                 , lowIntensity: .lowIntensitiy)
}




//MOVE ALL OF THIS
//FIRE BASE
//
