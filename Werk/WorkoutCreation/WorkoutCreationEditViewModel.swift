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
    }
    
    
    private func provideWorkoutName() -> String {
        workout.name
    }
    private func updateWorkoutName(updatedName: String) {
        workout.name = updatedName
    }

    func didSelectSave() {
        //expect some work to save this information
        service.saveWorkoutBlueprint(workoutBlueprint: workout)
    }
    
    func didSelectAddNewCycle() {
        workout.intervals.cycles.append(.initial)
        print("\(workout.intervals.cycles.count)")
    }
    
    func numberOfSetsText(_ interval: Interval) -> String {
        let sets = interval.numberOfSets
        return sets != 1 ? "\(sets) sets" : "\(sets) set"
    }
}






extension WorkoutCreationEditViewModel {
    func didUpdateIntervalBinding(interval: Interval) -> Binding<Interval> {
        Binding<Interval>.init { [weak self] in
            guard let self = self else { return interval }
            return self.intervals.cycles.first(where: {$0.id == interval.id }) ?? interval
        } set: { [weak self] updatedInterval in
            guard let self = self else { return }
            self.intervals.cycles = self.intervals.cycles.map {
                $0.id == updatedInterval.id ? updatedInterval : $0
            }
        }
    }
    
    func didUpdateWarmup(warmup: WorkoutPhase) {
        workout.warmup = warmup
    }
    

    func didUpdateRestBetweenPhases(restPhase: WorkoutPhase) {
        workout.intervals.restBetweenPhases = restPhase
    }
    
    
    func didUpdateCoolDown(coolDown: WorkoutPhase) {
        workout.cooldown = coolDown
    }
}

