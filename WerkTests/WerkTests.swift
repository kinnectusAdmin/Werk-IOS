
//  WerkTests.swift
//  WerkTests
//
//  Created by Shaquil Campbell on 10/2/22.
//

import XCTest
@testable import Werk
import Combine

struct MockDataService: DataStorageServiceIdentity {
    func saveWorkoutBlueprint(workoutBlueprint: WorkoutBlueprint) {}
    func saveWorkoutBlueprintRemote(workoutBlueprint: WorkoutBlueprint) {}
    func getWorkoutBlueprints() -> [WorkoutBlueprint] {
        []
    }
    func getWorkoutBlueprintsRemote() {}
    func saveRecordedWorkout(recordedWorkout: RecordedWorkout) {}
    func saveRecordedWorkoutRemote(recordedWorkout: RecordedWorkout) {}
    func getRecordedWorkoutsRemote() {}
    func observeWorkoutBlueprints() -> AnyPublisher<[WorkoutBlueprint], Never> {
        Just([]).eraseToAnyPublisher()
    }
    func observeRecordedWorkouts() -> AnyPublisher<[RecordedWorkout], Never> {
        Just([]).eraseToAnyPublisher()
    }
    func deleteWorkoutBlueprint(at workoutBlueprint: WorkoutBlueprint) {}
    func getLocalCurrentUser() -> UserModel? {
        nil
    }
    func fetchUpdatedWorkout(id: String) -> WorkoutBlueprint? {
        nil
    }
}

final class WerkTests: XCTestCase {
    
    func testViewModelInitialValues() {
        let warmUp = WorkoutPhase(id: UUID().uuidString, name: "WarmUp", hours: 0, minutes: 1, seconds: 0)
        let cooldown = WorkoutPhase(id: UUID().uuidString, name: "Cooldown", hours: 0, minutes: 1, seconds: 0)
        let highIntensity = WorkoutPhase(id: UUID().uuidString, name: "High Intensity", hours: 0, minutes: 1, seconds: 0)
        let lowIntensity = WorkoutPhase(id: UUID().uuidString, name: "Low Intensity", hours: 0, minutes: 1, seconds: 0)
        let restPhase = WorkoutPhase(id: UUID().uuidString, name: "Rest", hours: 0, minutes: 1, seconds: 0)
        let numberOfSets: Int = 1
        let order: Interval.Order = .startsWithHighIntensity
        let interval1 = Interval(id: UUID().uuidString,
                                 highIntensity: highIntensity,
                                 lowIntensity: lowIntensity,
                                 restPhase: restPhase,
                                 numberOfSets: numberOfSets,
                                 order: order)
        let cycles = [interval1]
        let intervals = IntervalCollection(_cycles: cycles, restBetweenPhases: restPhase)
        let bluePrint = WorkoutBlueprint(userId: UUID().uuidString,
                                         id: UUID().uuidString,
                                         name: "Workout",
                                         warmup: warmUp,
                                         intervals: intervals,
                                         cooldown: cooldown)
        let service = MockDataService()
        let viewModel = TimerViewModel(workout: bluePrint,
                                       service: service)
        XCTAssertTrue(Calendar.current.isDate(viewModel.startDate, equalTo: Date.now, toGranularity: .day))
        XCTAssertEqual(viewModel.workoutBlocks.count, 5)
        XCTAssertEqual(viewModel.currentPhaseIndex, 0)
        XCTAssertEqual(viewModel.currentPhaseType, .warmup)
        XCTAssertEqual(viewModel.maxPhaseIndex, 4)
        XCTAssertEqual(viewModel.isTimerFinished.wrappedValue, false)
        XCTAssertEqual(viewModel.currentPhaseName, "WarmUp")
        XCTAssertEqual(viewModel.currentPhaseTime, 60) //Initially should be warmup time duration - 0 since no time has elapsed from timer
        XCTAssertEqual(viewModel.elapsedTime, 0)
        XCTAssertEqual(viewModel.totalPlannedDuration, 300)
        XCTAssertEqual(viewModel.timeRemaining, 300)
        let warmupBlock = WorkoutBlock(name: "WarmUp", timeElapsed: 0, plannedDuration: 60, type: .warmup)
        XCTAssertEqual(viewModel.selectedPhase, warmupBlock)
        XCTAssertFalse(viewModel.isTimerActive)
        XCTAssertFalse(viewModel.isScreenLocked)
        XCTAssertEqual(viewModel.displayedPhasename, "WarmUp")
        XCTAssertEqual(viewModel.displayedSetInfo, "")
        XCTAssertEqual(viewModel.displayedElapsedTime,  "00:00 \nElapsed")
        XCTAssertEqual(viewModel.displayedTimeRemaining, "05:00 \nRemaining")
        XCTAssertEqual(viewModel.convertedCurrentPhaseTime, "01:00")
        XCTAssertEqual(viewModel.convertedTotalDuration, "05:00")
        XCTAssertEqual(viewModel.convertedElapsedTime, "00:00")
    }
    func testWorkoutBlocksAreArrangedAsExpected() {
        let warmUp = WorkoutPhase(id: UUID().uuidString, name: "WarmUp", hours: 0, minutes: 1, seconds: 0)
        let cooldown = WorkoutPhase(id: UUID().uuidString, name: "Cooldown", hours: 0, minutes: 1, seconds: 0)
        let highIntensity = WorkoutPhase(id: UUID().uuidString, name: "High Intensity", hours: 0, minutes: 1, seconds: 0)
        let lowIntensity = WorkoutPhase(id: UUID().uuidString, name: "Low Intensity", hours: 0, minutes: 1, seconds: 0)
        let rest = WorkoutPhase(id: UUID().uuidString, name: "Rest", hours: 0, minutes: 1, seconds: 0)
        let numberOfSets: Int = 1
        let order: Interval.Order = .startsWithHighIntensity
        let interval1 = Interval(id: UUID().uuidString,
                                 highIntensity: highIntensity,
                                 lowIntensity: lowIntensity,
                                 restPhase: rest,
                                 numberOfSets: numberOfSets,
                                 order: order)
        let cycles = [interval1]
        let intervals = IntervalCollection(_cycles: cycles, restBetweenPhases: rest)
        let bluePrint = WorkoutBlueprint(userId: UUID().uuidString,
                                         id: UUID().uuidString,
                                         name: "Workout",
                                         warmup: warmUp,
                                         intervals: intervals,
                                         cooldown: cooldown)
        let service = MockDataService()
        let viewModel = TimerViewModel(workout: bluePrint,
                                       service: service)
        
        let warmup = viewModel.workoutBlocks[0]
        let highIntensityPhase = viewModel.workoutBlocks[1]
        let lowIntensityPhase = viewModel.workoutBlocks[2]
        let restPhase = viewModel.workoutBlocks[3]
        let cooldownPhase = viewModel.workoutBlocks[4]
        
        XCTAssertEqual(warmup, WorkoutBlock(name: "WarmUp", timeElapsed: 0, plannedDuration: 60, type: .warmup))
        XCTAssertEqual(highIntensityPhase, WorkoutBlock(name: "High Intensity", timeElapsed: 0, plannedDuration: 60, type: .highIntensity))
        XCTAssertEqual(lowIntensityPhase, WorkoutBlock(name: "Low Intensity", timeElapsed: 0, plannedDuration: 60, type: .lowIntensity))
        XCTAssertEqual(restPhase, WorkoutBlock(name: "Rest", timeElapsed: 0, plannedDuration: 60, type: .restBetweenPhases))
        XCTAssertEqual(cooldownPhase, WorkoutBlock(name: "Cooldown", timeElapsed: 0, plannedDuration: 60, type: .coolDown))
    }
    
    func testDidPressNextPhaseBeforeWorkoutInitiated() {
        let warmUp = WorkoutPhase(id: UUID().uuidString, name: "WarmUp", hours: 0, minutes: 1, seconds: 0)
        let cooldown = WorkoutPhase(id: UUID().uuidString, name: "Cooldown", hours: 0, minutes: 1, seconds: 0)
        let highIntensity = WorkoutPhase(id: UUID().uuidString, name: "High Intensity", hours: 0, minutes: 1, seconds: 0)
        let lowIntensity = WorkoutPhase(id: UUID().uuidString, name: "Low Intensity", hours: 0, minutes: 1, seconds: 0)
        let restPhase = WorkoutPhase(id: UUID().uuidString, name: "Low Intensity", hours: 0, minutes: 1, seconds: 0)
        let numberOfSets: Int = 1
        let order: Interval.Order = .startsWithHighIntensity
        let interval1 = Interval(id: UUID().uuidString,
                                 highIntensity: highIntensity,
                                 lowIntensity: lowIntensity,
                                 restPhase: restPhase,
                                 numberOfSets: numberOfSets,
                                 order: order)
        let cycles = [interval1]
        let intervals = IntervalCollection(_cycles: cycles, restBetweenPhases: restPhase)
        let bluePrint = WorkoutBlueprint(userId: UUID().uuidString,
                                         id: UUID().uuidString,
                                         name: "Workout",
                                         warmup: warmUp,
                                         intervals: intervals,
                                         cooldown: cooldown)
        let service = MockDataService()
        let viewModel = TimerViewModel(workout: bluePrint,
                                       service: service)
        
        XCTAssertEqual(viewModel.currentPhaseIndex, 0)
        XCTAssertEqual(viewModel.currentPhaseType, .warmup)
        XCTAssertEqual(viewModel.currentPhaseName, "WarmUp")
        XCTAssertEqual(viewModel.timerElapsedTime, 0)
        XCTAssertEqual(viewModel.elapsedTime, 0)
        
        viewModel.didPressNextPhase()
        
        XCTAssertEqual(viewModel.currentPhaseIndex, 1)
        XCTAssertEqual(viewModel.currentPhaseType, .highIntensity)
        XCTAssertEqual(viewModel.currentPhaseName, "High Intensity")
        XCTAssertEqual(viewModel.timerElapsedTime, 0)
        XCTAssertEqual(viewModel.elapsedTime, 60)
        XCTAssertEqual(viewModel.timeRemaining, 240)
        let highIntensityBlock = WorkoutBlock(name: "High Intensity", timeElapsed: 0, plannedDuration: 60, type: .highIntensity)
        XCTAssertEqual(viewModel.selectedPhase, highIntensityBlock)
        XCTAssertEqual(viewModel.displayedPhasename, "High Intensity")
        XCTAssertEqual(viewModel.displayedSetInfo, "1/1 Set")
        XCTAssertEqual(viewModel.displayedElapsedTime,  "01:00 \nElapsed")
        XCTAssertEqual(viewModel.displayedTimeRemaining, "04:00 \nRemaining")
        XCTAssertEqual(viewModel.convertedCurrentPhaseTime, "01:00")
        XCTAssertEqual(viewModel.convertedTotalDuration, "05:00")
        XCTAssertEqual(viewModel.convertedElapsedTime, "01:00")
        viewModel.didPressNextPhase()
        
        XCTAssertEqual(viewModel.currentPhaseIndex, 2)
        XCTAssertEqual(viewModel.currentPhaseType, .lowIntensity)
        XCTAssertEqual(viewModel.currentPhaseName, "Low Intensity")
        XCTAssertEqual(viewModel.timerElapsedTime, 0)
        XCTAssertEqual(viewModel.elapsedTime, 120)
        XCTAssertEqual(viewModel.timeRemaining, 180)
        let lowIntensityBlock = WorkoutBlock(name: "Low Intensity", timeElapsed: 0, plannedDuration: 60, type: .lowIntensity)
        XCTAssertEqual(viewModel.selectedPhase, lowIntensityBlock)
        XCTAssertEqual(viewModel.displayedElapsedTime,  "02:00 \nElapsed")
        XCTAssertEqual(viewModel.displayedTimeRemaining, "03:00 \nRemaining")
        XCTAssertEqual(viewModel.convertedCurrentPhaseTime, "01:00")
        XCTAssertEqual(viewModel.convertedTotalDuration, "05:00")
        XCTAssertEqual(viewModel.convertedElapsedTime, "02:00")
        
        viewModel.didPressNextPhase()
        
        XCTAssertEqual(viewModel.currentPhaseIndex, 3)
        XCTAssertEqual(viewModel.currentPhaseType, .highIntensity)
        XCTAssertEqual(viewModel.currentPhaseName, "Rest")
        XCTAssertEqual(viewModel.timerElapsedTime, 0)
        XCTAssertEqual(viewModel.elapsedTime, 180)
        XCTAssertEqual(viewModel.timeRemaining, 120)
        let restBlock = WorkoutBlock(name: "Rest", timeElapsed: 0, plannedDuration: 60, type: .restBetweenPhases)
        XCTAssertEqual(viewModel.selectedPhase, restBlock)
        XCTAssertEqual(viewModel.displayedElapsedTime,  "03:00 \nElapsed")
        XCTAssertEqual(viewModel.displayedTimeRemaining, "02:00 \nRemaining")
        XCTAssertEqual(viewModel.convertedCurrentPhaseTime, "01:00")
        XCTAssertEqual(viewModel.convertedTotalDuration, "05:00")
        XCTAssertEqual(viewModel.convertedElapsedTime, "03:00")
        viewModel.didPressNextPhase()
        
        XCTAssertEqual(viewModel.currentPhaseIndex, 4)
        XCTAssertEqual(viewModel.currentPhaseType, .coolDown)
        XCTAssertEqual(viewModel.currentPhaseName, "Cooldown")
        XCTAssertEqual(viewModel.timerElapsedTime, 0)
        XCTAssertEqual(viewModel.elapsedTime, 240)
        XCTAssertEqual(viewModel.timeRemaining, 60)
        let cooldownBlock = WorkoutBlock(name: "Cooldown", timeElapsed: 0, plannedDuration: 60, type: .restBetweenPhases)
        XCTAssertEqual(viewModel.selectedPhase, cooldownBlock)
        XCTAssertEqual(viewModel.displayedElapsedTime,  "04:00 \nElapsed")
        XCTAssertEqual(viewModel.displayedTimeRemaining, "01:00 \nRemaining")
        XCTAssertEqual(viewModel.convertedCurrentPhaseTime, "01:00")
        XCTAssertEqual(viewModel.convertedTotalDuration, "05:00")
        XCTAssertEqual(viewModel.convertedElapsedTime, "04:00")
        
        
        viewModel.didPressNextPhase()
        //Should reset to beginning at first phase index ie, 0, with elapsed time set to zero
        XCTAssertEqual(viewModel.currentPhaseIndex, 0)
        XCTAssertEqual(viewModel.currentPhaseType, .warmup)
        XCTAssertEqual(viewModel.currentPhaseName, "WarmUp")
        XCTAssertEqual(viewModel.timerElapsedTime, 0)
        XCTAssertEqual(viewModel.elapsedTime, 0)
        XCTAssertFalse(viewModel.isTimerActive)
        XCTAssertEqual(viewModel.timeRemaining, 300)
    }
}

