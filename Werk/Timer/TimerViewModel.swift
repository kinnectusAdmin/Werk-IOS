//
//  TimerViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 6/1/23.
//

import Foundation
import SwiftUI

/*
 WorkoutBlock x 10
 Each block has its own individual planned Duration which does not change -> Constant
 Each block also a time elapsed -> this changes -> as that specific block is active and time passes
 Only one block will be active at a time.
 
 the total of the entire workout
 is comprised of the sum of all the workoutblocks PLANNED duration
 
 the time elapsed is the sum of all the workout blocks timeElapsed
 
 time remaining = (the sum of all the workoutblocks PLANNED duration) - (the sum of all the workout blocks timeElapsed)
 
 
 0 1 2 3 4 5
 */

class TimerViewModel: ObservableObject {
    private var workout: WorkoutBlueprint!
    @Published var workoutBlocks: [WorkoutBlock] =
    [
        WorkoutBlock(name: "Jump Rope", timeElapsed: 0, plannedDuration: 5, type: .warmup),
        WorkoutBlock(name: "Push Ups", timeElapsed: 0, plannedDuration: 10, type: .lowIntensity)
    ]
    @Published var currentPhaseIndex: Int = 0
    var currentPhaseType: Intensity = .warmup
    @Published var lastPhaseIndex: Int = 0
    @Published var maxPhaseIndex = 0
    var currentPhaseName: String {
        selectedPhase.name
    }
    @Published var setIndicator:String = ""
    private var timerElapsedTime: Int = 0
    var currentPhaseTime:Int {
        selectedPhase.plannedDuration - timerElapsedTime
    }
    @Published var elapsedTime:Int = 0
    @Published var totalPlannedDuration: Int = 0
    var timeRemaining: Int {
        abs(elapsedTime - totalPlannedDuration)
    }
    var selectedPhase: WorkoutBlock {
        workoutBlocks[currentPhaseIndex]
    }
    @Published var isTimerActive:Bool = false
    @Published var isScreenLocked:Bool = false
    
    @State var timer:Timer!
    
    init(workout: WorkoutBlueprint) {
        self.workout = workout
        
        //        $workoutBlocks.map { blocks in
        //            blocks.map { $0.timeElapsed }.reduce(0, +)
        //        }.map { [weak self] sum -> Int in
        //            guard let self = self else { return 0 }
        //            return self.totalPlannedDuration - sum
        //        }.assign(to: &$elapsedTime)
        
        //        totalPlannedDuration = workoutBlocks.map { durations in
        //            durations.plannedDuration}.reduce(0, +)
        
        totalPlannedDuration = workoutBlocks.map{ durations in
            durations.plannedDuration
            
        }.reduce(0, +)
        
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
        
//        workoutBlocks.append(warmupBlock)
//        workoutBlocks.append(contentsOf: cycleBlocks)
//        workoutBlocks.append(cooldownBlock)
        
    }
  
    
    func didPressExit(){
        
        //opens a menu that ask the user if they
    }
    
    func didPressEdit(){
        
        //when the edit button is pressed this should bring up the saved workoutCreationView for this saved workout
    }
    
    
    func didPressNextPhase() {
     //   for index in currentPhaseIndex 
        currentPhaseIndex += 1
        if currentPhaseIndex >= workoutBlocks.count{
            currentPhaseIndex = 0
            return  //change to save workout option later
        }
        timerElapsedTime = 0
        calculateElapsedTime()
//        switches to the next intensity phase but also adds the duration of the "swithced from" phase to the total time elapsed and subtracts it from the time remanning
    }
    
    func didPressPreviousPhase() {
        currentPhaseIndex -= 1
        if currentPhaseIndex <= 0 {
            currentPhaseIndex = 0
            elapsedTime = 0
            return
        }
        timerElapsedTime = 0
        calculateElapsedTime()
        //switches to the previous intensity phase but also resets the timer, time elaspsed and remaning time to the beginning of that phase
    }
    
    
    func didPressLock() {
        isScreenLocked = !isScreenLocked
        //toggles user touch input should disable other buttons not lock entire screen
    }
    
    func didPressStartorResume() {
        //starts or resumes timer
        isTimerActive.toggle()
            createTimer()
        
    }
    private func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] time in
            if self?.currentPhaseTime == 0 {
//                self?.timer?.invalidate()
                self?.timerElapsedTime = 0
                self?.didPressNextPhase()
            }
            else if self?.currentPhaseTime != 0 && self?.isTimerActive == true {
                self?.timerElapsedTime += 1
                self?.elapsedTime += 1
                
            }
        })
    }
    func didPressStop() {
        //        isTimerActive.toggle()
        timer.invalidate()
    }
    
    func didPressReset() {
        isTimerActive.toggle()
        timerElapsedTime = 0
        calculateElapsedTime()
    }
    
    func calculateElapsedTime() {
        let phaseDurations = workoutBlocks.map{ durations in
            durations.plannedDuration
        }
        var totalDurations = 0
        for index in (0...(currentPhaseIndex - 1)){
            let completedPhaseDuration = phaseDurations[index]
            totalDurations += completedPhaseDuration
            
        }
        elapsedTime = totalDurations
    }
    
    
}
// FINISH THIS IF STUCK THEN GO ADD SET FUNCTION TO WORKOUT CREATION REMEMBER TO SWITCH BRANCHES !
/*
 
 [0, 1, 2, 3]
 
 [Block 1, Block 2, Block 3, Block 4]
 
 [Blocks].map. { $0.plannedDuration }
 
 [Block 1 duration, Block 2 duration, Block 3 duration, Block 4 duration]
 
 
 [Block 1, Block 2, Block 3].map { $0.plannedDuration }.reduce(0, +)
 
 var totalDuration: Int = 0
 for block in blocks1 through 3 {
 totalDuration += block.plannedDuration
 }
 
 var totalDuration: Int = 0
 for index in (0...currentPhaseIndex) {
 let completedBlock = blocks[index]
 totalDuration += completedBlock.plannedDuration
 }
 
 
 When the user hits the next or previous button what is the time elapsed on your timer
 the timer has to reset to "0" which is the planned duration of the selceted phase
 */
