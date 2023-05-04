//
//  WorkoutEditViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 4/20/23.
//


import SwiftUI

class WorkoutEditViewModel:Identifiable, ObservableObject {
    
    @Published var selectedColorIndex: Int = 0
    @Published var workOutName = ""
    @Published var workout: Workout
    @Published var warmupDuration: String  = ""
    @Published var cooldownDuration: String = ""
    @Published var intervals: IntervalCollection = .initial
    @Published var lowIntensityDuration: String = ""
    @Published var highIntensityDuration: String = ""
    
    private let service: DataStorageServiceIdentity
    var workoutNameBinding: Binding<String> = .constant("")
    
    init(workout: Workout, service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        self.workout = workout
        self.workoutNameBinding = .init(get: provideWorkoutName, set: updateWorkoutName)
        $workout.map(\.warmup.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$warmupDuration)
        $workout.map(\.cooldown.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$cooldownDuration)
        $workout.map(\.intervals).assign(to: &$intervals)
        $workout.map(\.highIntensity.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$highIntensityDuration)
        $workout.map(\.lowIntensity.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$lowIntensityDuration)
    }
    
    
    private func provideWorkoutName() -> String {
        workout.name
    }
    private func updateWorkoutName(updatedName: String) {
        workout.name = updatedName
    }
    //    func didSelectCancel(){
    //        //goes back to previous screen
    //    }
    
    func didSelectSave() {
        //expect some wokr to save this information
        service.saveWorkout(workout: workout)
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






extension WorkoutEditViewModel {
    func didUpdateWarmup(warmup: WorkoutPhase) {
        workout.warmup = warmup
    }
    
    func didUpdateLowIntensity(lowIntensity: WorkoutPhase) {
        workout.lowIntensity = lowIntensity
    }
    
    func didUpdateHighIntensity(highIntensity: WorkoutPhase) {
        workout.highIntensity = highIntensity
    }
    
    func didUpdateCoolDown(coolDown: WorkoutPhase) {
        workout.cooldown = coolDown
    }
}

