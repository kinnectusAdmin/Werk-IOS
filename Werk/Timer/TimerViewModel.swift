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
    private var services: DataStorageServiceIdentity
    var soundModel = Audio()
    var workout: WorkoutBlueprint!
    @Published var circleProgress: CGFloat = 0.0
    @State var startDate = Date.now
    @Published var workoutBlocks: [WorkoutBlock] = []
    @Published var currentPhaseIndex: Int = 0
    @Published var currentPhaseType: Intensity = .warmup
    @Published var lastPhaseIndex: Int = 0
    @Published var maxPhaseIndex = 0
    var isTimerFinished: Binding<Bool> {
        .init {
            self.elapsedTime > 0 && (self.elapsedTime == self.totalPlannedDuration)
        } set: { _ in
            
        }

    }
    
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
    var timeRemaining: Int {  //Time remining in workout
        totalPlannedDuration - elapsedTime
    }
    var selectedPhase: WorkoutBlock { //Current phase of workout
        workoutBlocks[currentPhaseIndex]
    }
    @Published var isTimerActive:Bool = false
    @Published var isScreenLocked:Bool = false
    
    var displayedPhasename:String { //Current phase name
        "\(currentPhaseName)"
        
    }
    
    var displayedSetInfo:String {  //Number of sets in workout
        "\(currentPhaseIndex+1)/\(workoutBlocks.count) Set"
    }
    
    var displayedElapsedTime:String { //Time elpased during workout
        "\(convertedElapsedTime) \nElapsed"
    }
    
    var displayedTimeRemaining:String { //Time remaining in workout
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
        self.services = service
        self.workout = workout
        $workoutBlocks.map { blocks in
            blocks.map { $0.timeElapsed }.reduce(0, +)
        }.map { [weak self] sum -> Int in
            guard let self = self else { return 0 }
            return self.totalPlannedDuration - sum
        }.assign(to: &$elapsedTime)
        var cycleBlocks: [WorkoutBlock] = []
        
        for cycle in workout.intervals.cycles {
            if cycle.order == .startsWithHighIntensity {

                    cycleBlocks.append(contentsOf: (0...cycle.numberOfSets).map { cycleSet in
                        if cycleSet % 2 != 0 {
                            return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                        } else {
                            return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                        }
                    })
                if let rest = cycle.restPhase {
                    cycleBlocks.append(WorkoutBlock(name: rest.name, timeElapsed: 0, plannedDuration: rest.duration, type: .restBetweenPhases))
                }
//                }
            } else {
                if cycle.order == .startsWithLowIntensity {
                        cycleBlocks.append(contentsOf: (0...cycle.numberOfSets).map { cycleSet in
                            if cycleSet % 2 != 0 {
                                return WorkoutBlock(name: cycle.lowIntensity.name, timeElapsed: 0, plannedDuration: cycle.lowIntensity.duration, type: .lowIntensity)
                            } else {
                                return WorkoutBlock(name: cycle.highIntensity.name, timeElapsed: 0, plannedDuration: cycle.highIntensity.duration, type: .highIntensity)
                            }
                        })
                    if let rest = cycle.restPhase {
                        cycleBlocks.append(WorkoutBlock(name: rest.name, timeElapsed: 0, plannedDuration: rest.duration, type: .restBetweenPhases))
                    }
                }
            }
        }
        
        let warmupBlock = WorkoutBlock(name: workout.warmup.name, timeElapsed: 0, plannedDuration: workout.warmup.duration, type: .warmup)
        let cooldownBlock = WorkoutBlock(name: workout.cooldown.name, timeElapsed: 0, plannedDuration: workout.cooldown.duration, type: .coolDown)
        workoutBlocks = [warmupBlock] + cycleBlocks + [cooldownBlock]
        $elapsedTime.map { [weak self] time -> CGFloat in
            guard let self = self else { return 0.0 }
            let totalTime = self.totalPlannedDuration
            let percentTimeElapsed = time.toCGFloat/totalTime.toCGFloat
            print("\(totalTime)")
            print("\(percentTimeElapsed)")
            return 1 - percentTimeElapsed
        }.assign(to: &$circleProgress)
        maxPhaseIndex = workoutBlocks.count - 1
        
        totalPlannedDuration = workoutBlocks.map { durations in
            durations.plannedDuration
            
        }.reduce(0, +)
    }  // ^-- issue is present here
    
    func didPressExit(){
        //opens a menu that ask the user if they
    }
    
    func didPressEdit(){
        //when the edit button is pressed this should bring up the saved workoutCreationView for this saved workout
    }
    
    func didPressNextPhase() {
        //switches to the previous intensity phase but also resets the timer, time elaspsed and remaning time to the beginning of that phase
        currentPhaseIndex += 1
        if currentPhaseIndex >= workoutBlocks.count{
            currentPhaseIndex = 0
            saveTimedWorkout()
            return  // this should save the workout to the workout history and exit the timer
        }
        timerElapsedTime = 0
        calculateElapsedTime()
    }
    
    func didPressPreviousPhase() {
        //switches to the previous intensity phase but also resets the timer, time elaspsed and remaning time to the beginning of that phase
        currentPhaseIndex -= 1
        if currentPhaseIndex <= 0 {
            currentPhaseIndex = 0
            elapsedTime = 0
            return
        }
        timerElapsedTime = 0
        calculateElapsedTime()
    }
    
    
    func didPressLock() {
        //toggles user touch input should disable other buttons not lock entire screen
        isScreenLocked = !isScreenLocked
    }
    
    
    func didPressStartorResume() {
        // starts
        if elapsedTime == 0 && timer == nil {
            isTimerActive = true
            createTimer()
            return
        }
        // pause
        if  isTimerActive {
            isTimerActive = false
            return
        }
        // resume
        if !isTimerActive {
            isTimerActive = true
            return
        }
    }
    
    func didSelectSavedWorkout() {
        guard let user = services.getLocalCurrentUser() else { return }

        services.saveRecordedWorkout(recordedWorkout: RecordedWorkout(userId: user.id, name: workout.name, duration: Double(workout.duration), date: Date()))
        
    }
    
    
    
    private func createTimer() {
        // Creates a timer using the workout durtions as values
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
        //Fuction that starts the timer
        isTimerActive = false
        timerElapsedTime = 0
        calculateElapsedTime()
    }
    
    func calculateElapsedTime() {
        //Calculates the time that has elapsed during the current workout
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
        //saves the full duraiton of the workout that is completed
        let dataStorageService = DataStorageService()
        dataStorageService.saveWorkoutBlueprint(workoutBlueprint: self.workout)
    }
    
    func changeBackgroundColor(phaseName: String) -> Color {
        switch phaseName {
        case "Warm Up":
            return Color.orange // Timer color for Warm Up phase
        case "Low Intensity":
            return Color.blue // Timer color for Low Intensity phase
        case "High Intensity":
            return Color.red // Timer color for High Intensity phase
        case "Cool Down":
            return Color.cyan // Timer color for Cool Down phase
        case "Rest":
            return Color.green // Timer color for Rest phase
        default:
            return Color.gray // Default color for unknown phases
        }
    }
}

extension Int {
    var toCGFloat: CGFloat {
        CGFloat(self)
    }
}
