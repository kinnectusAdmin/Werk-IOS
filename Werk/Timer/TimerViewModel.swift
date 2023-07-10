//
//  TimerViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 6/1/23.
//

import Foundation
import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    private var workout: WorkoutBlueprint!
    @State var startDate = Date.now
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
        totalPlannedDuration - elapsedTime
    }
    var selectedPhase: WorkoutBlock {
        workoutBlocks[currentPhaseIndex]
    }
    @Published var isTimerActive:Bool = false
    @Published var isScreenLocked:Bool = false
    
    @State var timer:Timer!
    
    private var timerSubscription: AnyCancellable?
    
    
    
    
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
        
        //        elapsedTime = timer.countDownDuration
        
        
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
        // starts
        if elapsedTime == 0 && timer == nil {
            isTimerActive = true
            createTimer()
            return
        }
        ///pause
        if  isTimerActive {
            isTimerActive = false
            return
        }
        // resume
        if !isTimerActive {
            isTimerActive = true
            return
        }
        
        
        // if my timer is active create a timer to
    }
    
    
    private func createTimer() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.currentPhaseTime == 0 {
                    self.timerElapsedTime = 0
                    self.didPressNextPhase()
                } else if self.currentPhaseTime != 0 && self.isTimerActive {
                    self.timerElapsedTime += 1
                    self.elapsedTime += 1
                }
                if self.elapsedTime == self.totalPlannedDuration {
                    self.isTimerActive = false
                    self.timerSubscription?.cancel()
                }
            }
    }
    
    func didPressStop() {
        //        isTimerActive.toggle()
        timer.invalidate()
    }
    
    func didPressReset() {
        isTimerActive = false
        timerElapsedTime = 0
        calculateElapsedTime()
    }
    
    func calculateElapsedTime() {
        let phaseDurations = workoutBlocks.map{ durations in
            durations.plannedDuration
        }
        var totalDurations = 0
        for index in (0...currentPhaseIndex){
            let completedPhaseDuration = phaseDurations[index]
            totalDurations += completedPhaseDuration
            
        }
        elapsedTime = workoutBlocks[0..<currentPhaseIndex].map { $0.plannedDuration }.reduce(0, +)
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


//OLD TIMER

//timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: isTimerActive, block: { [weak self] time in
//            if self?.currentPhaseTime == 0 {
//                self?.timerElapsedTime = 0
//                self?.didPressNextPhase()
//            }
//            else if self?.currentPhaseTime != 0 && self?.isTimerActive == true {
//                self?.timerElapsedTime += 1
//                self?.elapsedTime += 1
//
//            }
//            if self?.elapsedTime == self?.totalPlannedDuration {
//                self?.isTimerActive = false
//
//            }
//        })
