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
    @Published var workoutBlocks: [WorkoutBlock] = []
    var currentPhaseIndex: Int = 0
    @Published var currentPhaseName:String = ""
    @Published var setIndicator:String = ""
    @Published var phaseTime:Int = 0
    @Published var elapsedTime:Int = 0
    private var totalPlannedDuration: Int = 90
    var timeRemaining: Int {
        abs(elapsedTime - totalPlannedDuration)
    }
    @Published var isTimerActive:Bool = false
    @Published var isScreenLocked:Bool = false
    
    
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
        
        

       // phaseTime = workoutBlocks[0].plannedDuration  <- same here ---v
        phaseTime = workoutBlocks.map{ phaseTime in
            phaseTime.plannedDuration
        }.first ?? 0
        
        //        currentPhaseName = workoutBlocks[currentPhaseIndex].name  <- why does this not work?
        currentPhaseName = workoutBlocks.map{phaseName in
            phaseName.name}.first ?? "nil"    //  <- is it because there are no workouts saved?
        
        
        
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
    
    @State var timer:Timer?
    
    func didPressExit(){
        
        //opens a menu that ask the user if they
    }
    
    func didPressEdit(){
        
        //when the edit button is pressed this should bring up the saved workoutCreationView for this saved workout
    }
    
    func didPressNextPhase() {
        currentPhaseIndex += 1
        if currentPhaseIndex >= workoutBlocks.count{
            currentPhaseIndex = 0
        }
//        var selectedPhase = workoutBlocks[currentPhaseIndex]
        var phaseDurations = workoutBlocks.map{ durations in
            durations.plannedDuration
        }
        var totalDurations = 0
        for index in (0...currentPhaseIndex){
            let completedPhaseDuration = phaseDurations[index]
            totalDurations += completedPhaseDuration
            
        }
        
        //switches to the next intensity phase but also adds the duration of the "swithced from" phase to the total time elapsed and subtracts it from the time remanning
    }
    
    func didPressPreviousPhase() {
        currentPhaseIndex -= 1
        if currentPhaseIndex < 0 {
            currentPhaseIndex = 0
        }
        var selectedPhase = workoutBlocks[currentPhaseIndex]
        var phaseDurations = workoutBlocks.map{ durations in
            durations.plannedDuration
        }
        var totalDurations = 0
        for index in (0...currentPhaseIndex){
            let completedPhaseDuration = phaseDurations[index]
            totalDurations += completedPhaseDuration
            
        }
        
        //switches to the previous intensity phase but also resets the timer, time elaspsed and remaning time to the beginning of that phase
    }
    
    
    func didPressLock() {
        isScreenLocked = !isScreenLocked
        //toggles user touch input should disable other buttons not lock entire screen
    }
    
    func didPressStartorResume() {
        //starts or resumes timer
        isTimerActive.toggle()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.elapsedTime += 1
        })
        
    }
    
    func didPressStop() {
        //        isTimerActive.toggle()
    }
    
    func didPressReset() {
        isTimerActive = false
        
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
