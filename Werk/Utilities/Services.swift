//
//  Services.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/8/23.
//

import Foundation
import SwiftUI



protocol DataStorageServiceIdentity {
    func saveWorkoutBlueprint(workoutBlueprint: WorkoutBlueprint)
    func getWorkoutBlueprint() -> [WorkoutBlueprint]?
    func saveRecordedWorkout(recordedWorkout: RecordedWorkout)
    func getRecordedWorkouts() -> [RecordedWorkout]

}

enum DataKey: String {
    case workoutBlueprint
    case recordedWorkouts
    
    

}

class DataStorageService: DataStorageServiceIdentity {
    
    
    
    func saveWorkoutBlueprint(workoutBlueprint: WorkoutBlueprint) {  //SAVES WORKOUT BLUEPRINT
        do {
            let currentSavedBluepint = getWorkoutBlueprint()
            let shouldRepacleWOrkout = currentSavedBluepint?.contains(where: {$0.id == workoutBlueprint.id})
            
            if shouldRepacleWOrkout! {
                //replace blueprint
                let newWorkoutBlueprintData: [Data] = (currentSavedBluepint?.replacing(workoutBlueprint).map {
                    do {
                        let data = try JSONEncoder().encode($0)
                        return data
                    } catch {
                        return nil
                    }
                }.compactMap{$0})!
                UserDefaults.standard.set(newWorkoutBlueprintData, forKey: "workoutBlueprint")
            } else {
                let newBlueprintData = try JSONEncoder().encode(workoutBlueprint)
                let allBlueprintData = getWorkoutBlueprintAsData().appending(newBlueprintData)
                UserDefaults.standard.set(allBlueprintData, forKey: "workoutBlueprint")
            }
        } catch {
            print("Error saving WorkoutBlueprint: \(error.localizedDescription)")
        }
    }

    func getWorkoutBlueprint() -> [WorkoutBlueprint]? { //RETREIVES WORKOUT BLUEPRINT
        getWorkoutBlueprintAsData().map {
            do {
                let blueprint: WorkoutBlueprint = try JSONDecoder().decode(WorkoutBlueprint.self, from: $0)
                return blueprint
            } catch {
                return nil
            }
        }.compactMap{$0}
    }
    
func getWorkoutBlueprintAsData() -> [Data] {
    return []
}

    // do the same ^
    
    func saveRecordedWorkout(recordedWorkout: RecordedWorkout) {
        do {
            let currentSavedWorkouts = getRecordedWorkouts()
            let shouldReplaceWorkout = currentSavedWorkouts.contains(where: { $0.id == recordedWorkout.id})
            
            if shouldReplaceWorkout {
                //replace workout
                let newWorkoutData: [Data] = currentSavedWorkouts.replacing(recordedWorkout).map {
                    do {
                        let data = try JSONEncoder().encode($0)
                        return data
                    } catch {
                        return nil
                    }
                }.compactMap { $0 }
                UserDefaults.standard.set(newWorkoutData, forKey: "recordedWorkouts")

            } else {
                let newWorkoutData = try JSONEncoder().encode(recordedWorkout)
                let allWorkoutData = getRecordedWorkoutsAsData().appending(newWorkoutData)
                UserDefaults.standard.set(allWorkoutData, forKey: "recordedWorkouts")
            }
        } catch {
            print("Error saving RecordedWorkout: \(error.localizedDescription)")
        }
    }
    
    func getRecordedWorkouts() -> [RecordedWorkout] {
        getRecordedWorkoutsAsData().map {
            do {
                let workout: RecordedWorkout = try JSONDecoder().decode(RecordedWorkout.self, from: $0)
                return workout
            } catch {
                return nil
            }
        }.compactMap { $0 }
    }
    func getRecordedWorkoutsAsData() -> [Data] {
        return []
    }
}

extension Array {
    func appending(_ element: Element) -> Self {
        return self + [element]
    }
}
extension Array where Element: Equatable {
    func replacing(_ element: Element) -> Self {
        var copy = self
        let index = copy.firstIndex(where: {$0 == element }) ?? 0
        copy.remove(at: copy.distance(from: copy.startIndex, to: index))
        copy.insert(element, at: copy.distance(from: copy.startIndex, to: index))
        return copy
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
