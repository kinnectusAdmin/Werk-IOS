//
//  WorkOutData.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import Foundation
import SwiftUI


enum Sound {
    case ding, dingding
}

struct WorkoutPhase: Identifiable, Hashable {
    let id: String
    var name: String
    var duration: Double
    var color: Color
    var sound: Sound
}

extension WorkoutPhase {
    static var coolDown = WorkoutPhase.init(id: UUID().uuidString, name: "Cool Down", duration: 0.0, color: .blue, sound: .ding)
    static let warmUP = WorkoutPhase(id: UUID().uuidString, name: "Warm Up", duration: 0.0, color: .yellow, sound: .dingding)
    static let lowIntensitiy = WorkoutPhase(id: UUID().uuidString, name: "Low Intentsity", duration: 10.0, color: .cyan, sound: .ding)
    static let highItensitity = WorkoutPhase(id: UUID().uuidString, name: "High Intensitiy", duration: 20.0, color: .red, sound: .dingding)
    static let rest = WorkoutPhase(id: UUID().uuidString, name: "Rest Between Cycles", duration: 00.0, color: .indigo, sound: .dingding)
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




