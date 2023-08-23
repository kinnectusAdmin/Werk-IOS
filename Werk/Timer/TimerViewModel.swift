//
//  TimerViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 6/1/23.
//

import Foundation
import SwiftUI
import Combine
import AudioToolbox

class TimerViewModel: ObservableObject {
    var soundModel = Audio()
    var workout: WorkoutBlueprint!
    @Published var circleProgress: CGFloat = 0.0
    @State var startDate = Date.now
    @Published var workoutBlocks: [WorkoutBlock] =
    [
        WorkoutBlock(name: "Jump Rope", timeElapsed: 0, plannedDuration: 65, type: .warmup),
        WorkoutBlock(name: "Push Ups", timeElapsed: 0, plannedDuration: 110, type: .lowIntensity)
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
    
    var displayedPhasename:String {
        "\(currentPhaseName)"
        
    }
    
    var displayedSetInfo:String {
        "\(currentPhaseIndex+1)/\(workoutBlocks.count) Set"
    }
    
    var displayedElapsedTime:String {
        "\(convertedElapsedTime) \nElapsed"
    }
    
    var displayedTimeRemaining:String {
        "\(convertedTotalDuration) \nRemaining"
    }
        
    
    
    var convertedCurrentPhaseTime:String { //shows String in 00:00 format
        return String(format: "%02d:%02d", (currentPhaseTime / 60), (currentPhaseTime % 60))
    }
    
    var convertedTotalDuration:String { //shows String in 00:00 format
        return String(format: "%02d:%02d", (totalPlannedDuration / 60), (totalPlannedDuration % 60))
    }
    
    var convertedElapsedTime:String { //shows String in 00:00 format
        return String(format: "%02d:%02d", (elapsedTime / 60), (elapsedTime % 60))
    }
    @State var timer:Timer!
    
    private var timerSubscription: AnyCancellable?
    
    
    
    init(workout: WorkoutBlueprint, service: DataStorageServiceIdentity = DataStorageService()) {
        self.workout = workout
                $workoutBlocks.map { blocks in
                    blocks.map { $0.timeElapsed }.reduce(0, +)
                }.map { [weak self] sum -> Int in
                    guard let self = self else { return 0 }
                    return self.totalPlannedDuration - sum
                }.assign(to: &$elapsedTime)
        
                totalPlannedDuration = workoutBlocks.map { durations in
                    durations.plannedDuration}.reduce(0, +)
        
        totalPlannedDuration = workoutBlocks.map{ durations in
            durations.plannedDuration
            
        }.reduce(0, +)
        
        var cycleBlocks: [WorkoutBlock] = []

        for cycle in workout.intervals.cycles {
            if cycle.order == .startsWithHighIntensity {
                if workout.intervals.restBetweenPhases.duration > 0 {
                    let phases = (0...cycle.numberOfSets).map { cycleSet in
                        if cycleSet % 2 != 0 {
                            return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                        } else {
                            return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                        }
                    }
                    let rests = Array(repeating: WorkoutBlock(name: "rest", timeElapsed: 0, plannedDuration: workout.intervals.restBetweenPhases.duration, type: .restBetweenPhases), count: phases.count - 1)
                    cycleBlocks.append(contentsOf: zip(phases, rests).flatMap { $0 + [$1] })
                } else {
                    cycleBlocks.append(contentsOf: (0...cycle.numberOfSets).map { cycleSet in
                        if cycleSet % 2 != 0 {
                            return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                        } else {
                            return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                        }
                    })
                }
            } else {
                if workout.intervals.restBetweenPhases.duration > 0 {
                    let phases = (0...cycle.numberOfSets).map { cycleSet in
                        if cycleSet % 2 != 0 {
                            return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                        } else {
                            return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                        }
                    }
                    let rests = Array(repeating: WorkoutBlock(name: "rest", timeElapsed: 0, plannedDuration: workout.intervals.restBetweenPhases.duration, type: .restBetweenPhases), count: phases.count - 1)
                    cycleBlocks.append(contentsOf: zip(phases, rests).flatMap { $0 + [$1] })
                } else {
                    cycleBlocks.append(contentsOf: (0...cycle.numberOfSets).map { cycleSet in
                        if cycleSet % 2 != 0 {
                            return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                        } else {
                            return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                        }
                    })
                }
            }
        }

        let warmupBlock = WorkoutBlock(name: workout.warmup.name, timeElapsed: 0, plannedDuration: workout.warmup.duration, type: .warmup)
        let cooldownBlock = WorkoutBlock(name: workout.cooldown.name, timeElapsed: 0, plannedDuration: workout.cooldown.duration, type: .coolDown)

        workoutBlocks = [warmupBlock] + cycleBlocks + [cooldownBlock]

        //        workoutBlocks.append(warmupBlock)
        //        workoutBlocks.append(contentsOf: cycleBlocks)
        //        workoutBlocks.append(cooldownBlock)
        
        $elapsedTime.map { [weak self] time -> CGFloat in
            guard let self = self else { return 0 }
            let totalTime = self.totalPlannedDuration
            let percentTimeElapsed = time.toCGFloat/totalTime.toCGFloat
            return 1 - percentTimeElapsed
        }.assign(to: &$circleProgress)
        
        
        maxPhaseIndex = workoutBlocks.count - 1
        
        
        
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
            saveTimedWorkout()
            return  // this should save the workout to the workout history and exit the timer
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
                guard let self = self else { return }  //REMEMBER: so i dont have to unwrap or make each one of these optionals v
                if self.currentPhaseTime == 0 {
                    self.timerElapsedTime = 0
                    AudioServicesPlaySystemSound(SystemSoundID(1309))
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
    
    private func saveTimedWorkout() {
        let dataStorageService = DataStorageService()
        dataStorageService.saveWorkoutBlueprint(workoutBlueprint: self.workout)
    }
    
}




extension Int {
    var toCGFloat: CGFloat {
        CGFloat(self)
    }
}
