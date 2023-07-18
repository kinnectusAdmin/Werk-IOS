//
//  WorkoutCreationViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/8/22.
//

import Foundation
import SwiftUI
import Combine



class WorkoutCreationEditViewModel:Identifiable, ObservableObject {
    
    @Published var selectedColorIndex: Int = 0
    @Published var workOutName = ""
    @Published var workout: WorkoutBlueprint
    @Published var warmupDuration: String  = ""
    @Published var cooldownDuration: String = ""
    @Published var intervals: IntervalCollection = .initial
    @Published var lowIntensityDuration: String = ""
    @Published var highIntensityDuration: String = ""
    
    private let service: DataStorageServiceIdentity
    var workoutNameBinding: Binding<String> = .constant("")
    
    init(workout: WorkoutBlueprint = WorkoutBlueprint.initial, service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        self.workout = workout
        self.workoutNameBinding = .init(get: provideWorkoutName, set: updateWorkoutName)
        $workout.map(\.warmup.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$warmupDuration)
        $workout.map(\.cooldown.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$cooldownDuration)
        $workout.map(\.intervals).assign(to: &$intervals)
//        $workout.map(\.highIntensity.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$highIntensityDuration)
//        $workout.map(\.lowIntensity.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$lowIntensityDuration)
        
    }
    
    
    private func provideWorkoutName() -> String {
        workout.name
    }
    private func updateWorkoutName(updatedName: String) {
        workout.name = updatedName
    }

    func didSelectSave() {
        //expect some wokr to save this information
        service.saveWorkoutBlueprint(workoutBlueprint: workout)
    }
    
    func didSelectAddNewCycle() {
        workout.intervals.cycles.append(.initial)
        print("\(workout.intervals.cycles.count)")
    }
}






extension WorkoutCreationEditViewModel {
    func didUpdateWarmup(warmup: WorkoutPhase) {
        workout.warmup = warmup
    }
    

    func didUpdateIntervals(intervals: WorkoutPhase) {
        workout.intervals.restBetweenPhases = intervals
    }
    
    
    func didUpdateCoolDown(coolDown: WorkoutPhase) {
        workout.cooldown = coolDown
    }
}

