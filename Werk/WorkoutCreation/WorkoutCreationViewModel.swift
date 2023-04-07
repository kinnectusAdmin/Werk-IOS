//
//  WorkoutCreationViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/8/22.
//

import Foundation
import SwiftUI
import Combine


class WorkoutCreationViewModel:Identifiable, ObservableObject {
    
    @Published var bgColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    @Published var workOutName = ""
    @Published var workout: Workout = Workout.initial
    @Published var warmupDuration: String  = ""
    @Published var cooldownDuration: String = ""
    @Published var intervals: IntervalCollection = .initial
    @Published var lowIntensityDuration: String = ""
    @Published var highIntensityDuration: String = ""
    
    var workoutNameBinding: Binding<String> = .constant("")
    
    init() {
        self.workoutNameBinding = .init(get: provideWorkoutName, set: updateWorkoutName)
        $workout.map(\.warmup.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$warmupDuration)
        $workout.map(\.cooldown.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$cooldownDuration)
        $workout.map(\.intervals).assign(to: &$intervals)
        $workout.map(\.highIntensity.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$highIntensityDuration)
        $workout.map(\.lowIntensity.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$lowIntensityDuration)
    }
    
    
    private func provideWorkoutName() -> String {
        workOutName
    }
    private func updateWorkoutName(updatedName: String) {
        workOutName = updatedName
    }
//    func didSelectCancel(){
//        //goes back to previous screen
//    }
    
    func didSelectSave() {
        //expect some wokr to save this information
    }
//    func didSelectPhase(phase: WorkoutPhase) {
//
//    }
//
//    func didSelectNumberOfSets() {
//
//    }

    func didSelectAddNewCycle() {
        workout.intervals.cycles.append(.initial)
        print("\(workout.intervals.cycles.count)")
        //        extension IntervalCollection {
        //            static let initial = IntervalCollection(cycles: [.initial, .initial], restBetweenPhases: .rest)
        //        }
    }
    
    
    
    
}






extension WorkoutCreationViewModel {
    func didUpdateWarmup(warmup: WorkoutPhase) {
        workout.warmup = warmup
    }
}

