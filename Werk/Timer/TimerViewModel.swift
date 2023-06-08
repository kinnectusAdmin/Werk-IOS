//
//  TimerViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 6/1/23.
//

import Foundation
import SwiftUI


class TimerViewModel: ObservableObject {
    private var workout: WorkoutBlueprint!
    var workoutBlocks: [WorkoutBlock] = []
    var currentPhaseIndex: Int = 0
    @Published var currentPhase:String = ""
    @Published var setIndicator:String = ""
    @Published var phaseTime:String = ""
    @Published var elapsedTime:String = ""
    @Published var timeRemaining:Int = 0
    @Published var isTimerActive:Bool = false
    @State var isScreenLocked:Bool = false
    
    init(workout: WorkoutBlueprint) {
        self.workout = workout
        let cycleBlocks = workout.intervals.cycles.map { cycle in
            if cycle.order == .startsWithHighIntensity {
                return (0...cycle.numberOfSets).map { cycleSet in
                    if cycleSet % 2 != 0 {
                        return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                    } else {
                        return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                    }
                }
            } else {
                return (0...cycle.numberOfSets).map { cycleSet in
                    if cycleSet % 2 != 0 {
                        return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                    } else {
                        return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                    }
                }
            }
        }.reduce([WorkoutBlock](), +)
        
        let warmupBlock = WorkoutBlock(name: workout.warmup.name, timeElapsed: 0, plannedDuration: workout.warmup.duration, type: .warmup)
        let cooldownBlock = WorkoutBlock(name: workout.cooldown.name, timeElapsed: 0, plannedDuration: workout.cooldown.duration, type: .coolDown)
        
        workoutBlocks.append(warmupBlock)
        workoutBlocks.append(contentsOf: cycleBlocks)
        workoutBlocks.append(cooldownBlock)
        
    }
    
    @State var timer:Timer
    
    func didPressExit(){
        
        //opens a menu that ask the user if they
    }
    
    func didPressEdit(){
        
        //when the edit button is pressed this should bring up the saved workoutCreationView for this saved workout
    }
    
    func didPressPreviousPhase() {
        
        //switches to the previous intensity phase but also resets the timer, time elaspsed and remaning time to the beginning of that phase
    }
    
    func didPressNextPhase() {
        
        //switches to the next intensity phase but also adds the duration of the "swithced from" phase to the total time elapsed and subtracts it from the time remanning
    }
    
    func didPressLock() {
        Toggle("lock", isOn: $isScreenLocked)
        
        //toggles user touch input
    }
    
    func didPressStartorResume()-> Int {
        //starts or resumes timer
        isTimerActive.toggle()
        timeRemaining = workoutBlocks.map { durations in
            durations.plannedDuration
        }.reduce(0, +)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.timeRemaining -= 1
        })
        return timeRemaining
    }
    
    func didPressStop() {
        isTimerActive.toggle()
    }
    
    func didPressReset() {
        isTimerActive = false
        
    }
    

}


// FINISH THIS IF STUCK THEN GO ADD SET FUNCTION TO WORKOUT CREATION REMEMBER TO SWITCH BRANCHES !
