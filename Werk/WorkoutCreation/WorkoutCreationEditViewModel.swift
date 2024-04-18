//
//  WorkoutCreationViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/8/22.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class WorkoutCreationEditViewModel:Identifiable, ObservableObject {
    
    @Published var selectedColorIndex: Int = 0
    @Published var workOutName = ""
    @Published var workout: WorkoutBlueprint
    @Published var warmupDuration: String  = ""
    @Published var cooldownDuration: String = ""
    @Published var intervals: IntervalCollection = .initial
    @Published var lowIntensityDuration: String = ""
    @Published var highIntensityDuration: String = ""
    @Published var restBetweenPhasesDuration: String = ""
    @Published var showRestBetweenCycles = false
    var onWorkoutUpdate: ((WorkoutBlueprint) -> Void)?
    @Published var colors:[Color] =
    [
        Color.red, Color.blue, Color.green, Color.indigo, Color.orange, Color.yellow, Color.mint, Color.cyan, Color.purple, Color.teal, Color.pink, Color.gray
    ]
    private let service: DataStorageServiceIdentity
    var workoutNameBinding: Binding<String> = .constant("")
    
    init(workout: WorkoutBlueprint = WorkoutBlueprint.initial(), service: DataStorageServiceIdentity = DataStorageService(), onWorkoutUpdate: ((WorkoutBlueprint) -> Void)? = nil) {
        self.service = service
        self.workout = workout
        self.onWorkoutUpdate = onWorkoutUpdate
        self.workoutNameBinding = .init(get: provideWorkoutName, set: updateWorkoutName)
        $workout.map(\.warmup.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$warmupDuration)
        $workout.map(\.cooldown.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$cooldownDuration)
        $workout.map(\.intervals).assign(to: &$intervals)
        $workout.map(\.intervals.restBetweenPhases.duration).map({durationOfWorkout(duration: Double($0))}).assign(to: &$restBetweenPhasesDuration)
    }
    
    private func provideWorkoutName() -> String {
        workout.name
    }
    
    private func updateWorkoutName(updatedName: String) {
        workout.name = updatedName
    }
    
    
    func didSelectSave() {//make if else statement for filter if true update workout if false save workout
        //expect some work to save this information
        guard let user = service.getLocalCurrentUser() else { return }
        workout.userId = user.id
        service.saveWorkoutBlueprintRemote(workoutBlueprint: workout)
        onWorkoutUpdate?(workout)
    }
        
        func didSelectAddNewCycle() {
            workout.intervals._cycles.append(Interval.initial())
            
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
            print("Did update interval")
            return self.workout.intervals._cycles.first(where: {$0.id == interval.id }) ?? interval                  //<---------issue might be here
        } set: { [weak self] updatedInterval in
            guard let self = self else { return }
            self.workout.intervals._cycles = self.workout.intervals._cycles.map {
                $0.id == interval.id ? updatedInterval : $0
            }
        }
    }
    
//    func didUpdateIntervalBinding(interval: Interval) -> Binding<Interval> {       //<----  test to see what is returned when this fuction runs
//        Binding<Interval>(
//            get: {
//                return interval
//            },
//            set: { updatedInterval in
//                print("Received updated interval: \(updatedInterval)")
//                self.workout.intervals._cycles[0] = updatedInterval
//            }
//        )
//    }
        
    
    func didUpdateWarmupBinding() -> Binding<WorkoutPhase> {
        Binding<WorkoutPhase> {
            self.workout.warmup
        } set: { warmUp, _ in
            self.workout.warmup = warmUp
        }
        
    }
    
    func didUpdateRestBetweenPhases(restPhase: WorkoutPhase) -> Binding<WorkoutPhase> {
        Binding<WorkoutPhase> {
            self.intervals.restBetweenPhases
        } set: { rest, _ in
            self.intervals.restBetweenPhases = rest
        }
    }
    
    func didUpdateCoolDownBinding() -> Binding<WorkoutPhase> {
        Binding<WorkoutPhase> {
            self.workout.cooldown
        } set: { coolDown, _ in
            self.workout.cooldown = coolDown
        }
    }
    
    func didUpdateRestBinding() -> Binding<WorkoutPhase> {
        Binding<WorkoutPhase> {
            self.workout.intervals.restBetweenPhases
        } set: { rest, _ in
            self.workout.intervals.restBetweenPhases = rest
        }
    }
}

