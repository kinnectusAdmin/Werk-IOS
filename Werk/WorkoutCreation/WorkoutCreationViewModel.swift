//
//  WorkoutCreationViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/8/22.
//

import Foundation
import SwiftUI
import Combine

class WorkoutCreationViewModel:ObservableObject {
    
    
    @Published var workOutName = ""
    
    @Published var workout: Workout = Workout.initial
    @Published var warmupDuration: String  = ""
    @Published var cooldownDuration: String = ""
    @Published var setNumber: [Interval] = [Interval.initial]
    @Published var lowIntensityDuration: String = ""
    @Published var highIntensityDuration: String = ""
   
    var workoutNameBinding: Binding<String> = .constant("")
    
    init() {
        self.workoutNameBinding = .init(get: provideWorkoutName, set: updateWorkoutName)
        $workout.map(\.warmup.duration).map({durationOfWorkout(duration: $0)}).assign(to: &$warmupDuration)
        $workout.map(\.cooldown.duration).map({durationOfWorkout(duration: $0)}).assign(to: &$cooldownDuration)
        $workout.map(\.intervals.cycles).assign(to: &$setNumber)
        $workout.map(\.highIntensity.duration).map({durationOfWorkout(duration: $0)}).assign(to: &$highIntensityDuration)
        $workout.map(\.lowIntensity.duration).map({durationOfWorkout(duration: $0)}).assign(to: &$lowIntensityDuration)
    }
    private func provideWorkoutName() -> String {
        workOutName
    }
    private func updateWorkoutName(updatedName: String) {
        workOutName = updatedName
    }
    func didSelectCancel(){
        //goes back to previous screen
    }
    
    func didSelectSave() {
        //expect some wokr to save this information
    }
    func didSelectPhase(phase: WorkoutPhase) {
        
    }
    
    func didSelectNumberOfSets() {
        
    }
    
    func didSelectAddNewCycle() {
        
    }
    
    
    
    
}

enum Sound {
    case ding, dingding
}

struct WorkoutPhase {
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

struct Interval {
    enum Order {
        case startsWithHighIntensity
        case startsWithLowIntensity
    }
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











