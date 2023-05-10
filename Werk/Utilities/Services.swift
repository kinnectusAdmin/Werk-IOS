//
//  Services.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/8/23.
//

import Foundation
import SwiftUI



protocol DataStorageServiceIdentity {
    func saveWorkoutBlueprint(workout: WorkoutBlueprint)
    func getWorkoutBlueprint() -> WorkoutBlueprint?
    func saveRecordedWorkout(recordedWorkout: RecordedWorkout)
    func getRecordedWorkout() -> RecordedWorkout?
//    func getRecordedWorkout() -> Bar?
}

enum DataKey: String {
    case workout
    case recordedWorkout
    
    

}

class DataStorageService: DataStorageServiceIdentity {
    
    
    
    func saveWorkoutBlueprint(workout: WorkoutBlueprint) {  //SAVES WORKOUT BLUEPRINT
        do{
            let data = try JSONEncoder().encode(workout)
            UserDefaults.standard.setValue(data, forKey: DataKey.workout.rawValue)
            
        } catch {
            print(error.localizedDescription)
        }
    }

    func getWorkoutBlueprint() -> WorkoutBlueprint? { //RETREIVES WORKOUT BLUEPRINT
        do {
            guard let data =  UserDefaults.standard.data(forKey: DataKey.workout.rawValue) else {
                return nil
            }
            let workout = try JSONDecoder().decode(WorkoutBlueprint.self, from: data)
            return workout
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveRecordedWorkout(recordedWorkout: RecordedWorkout) {
        do {
            let data = try JSONEncoder().encode(recordedWorkout)
            UserDefaults.standard.set(data, forKey: "recordedWorkout")
        } catch {
            print("Error saving RecordedWorkout: \(error.localizedDescription)")
        }
    }
    
    func getRecordedWorkout() -> RecordedWorkout? {
        guard let data = UserDefaults.standard.data(forKey: "recordedWorkout") else {
            return nil
        }
        do {
            let recordedWorkout = try JSONDecoder().decode(RecordedWorkout.self, from: data)
            return recordedWorkout
        } catch {
            print("Error fetching RecordedWorkout: \(error.localizedDescription)")
            return nil
        }
    }
}













//    func saveRecordedWorkout(recordedWorkout: RecordedWorkout) {
//        do {
//            let data = try JSONEncoder().encode(recordedWorkout)
//            UserDefaults.standard.setValue(data, forKey: DataKey.recordedWorkout.rawValue)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//


//    func getRecordedWorkout() -> Bar? { //RETREIVES RECORDED WORKOUT
//        do {
//            guard let data = UserDefaults.standard.data(forKey: DataKey.recordedWorkout.rawValue) else {
//                return nil
//            }
//            let recordedWorkout = try JSONDecoder().decode(RecordedWorkout.self, from: data)
//            return Bar.map {
//                recordedWorkout in
//                return recordedWorkout
//            }
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
