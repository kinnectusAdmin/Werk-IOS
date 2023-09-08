//
//  Services.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/8/23.
//

import Foundation
import SwiftUI
import Combine
import Firebase

protocol DataStorageServiceIdentity {
    func saveWorkoutBlueprint(workoutBlueprint: WorkoutBlueprint)
    func saveWorkoutBlueprintRemote(workoutBlueprint: WorkoutBlueprint)
    func getWorkoutBlueprints() -> [WorkoutBlueprint]
    func getWorkoutBlueprintsRemote()
    func saveRecordedWorkout(recordedWorkout: RecordedWorkout)
    func getRecordedWorkouts() -> [RecordedWorkout]
    
    func getRecordedWorkoutsRemote()
    
    func observeWorkoutBlueprints() -> AnyPublisher<[WorkoutBlueprint], Never>
    func observeRecordedWorkouts() -> AnyPublisher<[RecordedWorkout], Never>
    func deleteWorkoutBlueprint(at workoutBlueprint: WorkoutBlueprint)
    
}

enum DataKey: String {
    case workoutBlueprint
    case recordedWorkouts
}

class DataStorageService: DataStorageServiceIdentity {
   

    func saveWorkoutBlueprint(workoutBlueprint: WorkoutBlueprint) { //LOCAL STORAGE
        saveWorkoutBlueprintRemote(workoutBlueprint: workoutBlueprint)
        //SAVES WORKOUT BLUEPRINT
        do {
            let currentSavedBlueprints = getWorkoutBlueprints()
            let shouldRepacleWorkout = currentSavedBlueprints.contains(where: {$0.id == workoutBlueprint.id})

            if shouldRepacleWorkout {
                //replace blueprint
                let newWorkoutBlueprintData: [Data] = (currentSavedBlueprints.replacing(workoutBlueprint).map {
                    do {
                        let data = try JSONEncoder().encode($0)
                        return data
                    } catch {
                        return nil
                    }
                }.compactMap{$0})

                UserDefaults.standard.workoutBlueprints = newWorkoutBlueprintData
            } else {
                let newBlueprintData = try JSONEncoder().encode(workoutBlueprint)
                let allBlueprintData = getWorkoutBlueprintAsData().appending(newBlueprintData)
                UserDefaults.standard.workoutBlueprints = allBlueprintData
            }
        } catch {
            print("Error saving WorkoutBlueprint: \(error.localizedDescription)")
        }
    }
    
    func saveWorkoutBlueprintRemote(workoutBlueprint: WorkoutBlueprint) { //LOCAL STORAGE
        let dataStore = Firestore.firestore().collection(DataKey.workoutBlueprint.rawValue)
        //whenever I want to create an instance of a data base use fireStore.Firetore().collection
        let query = dataStore.addDocument(data: DataStorageService.convertBlueprintToDictionary(blueprint: workoutBlueprint)) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Did save blueprint")
            }
        }
        //stores my workout
        
    }
    
    func getWorkoutBlueprints() -> [WorkoutBlueprint] { //RETREIVES WORKOUT BLUEPRINT
        getWorkoutBlueprintAsData().map {
            do {
                let blueprint: WorkoutBlueprint = try JSONDecoder().decode(WorkoutBlueprint.self, from: $0)
                getWorkoutBlueprintsRemote()
                return blueprint
            } catch {
                return nil
            }
        }.compactMap{$0}
    }
    
    func getWorkoutBlueprintsRemote(){ //FIREBASE
        let dataStore = Firestore.firestore().collection("workoutBlueprint")
        dataStore.getDocuments { queryCall, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let queryCall = queryCall {
                      let remoteWorkoutBlueprints = queryCall.documents.compactMap { w -> WorkoutBlueprint? in
                        guard let name = w["name"] as?  String,
                              let warmup = w["warmup"] as? WorkoutPhase,
                              let intervals = w["intervals"] as? IntervalCollection,
                              let cooldown = w["cooldown"] as? WorkoutPhase else {
                            return nil
                        }
                          return WorkoutBlueprint(name: name, warmup: warmup, intervals: intervals, cooldown: cooldown)
                    }
                }
            }
        }
    }
    
    func saveRecordedWorkout(recordedWorkout: RecordedWorkout) { //LOCAL STORAGE
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
    
    func saveRecordedWorkoutsRemote(recordedWorkout: RecordedWorkout) { //FIREBASE
        let dataStore = Firestore.firestore().collection(DataKey.recordedWorkouts.rawValue)
        let query = dataStore.addDocument(data: DataStorageService.convertRecordedWorkoutToDictionary(recordedWorkout: recordedWorkout)) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Did save recorded workout")
            }
        }
    }
    
    func deleteWorkoutRemote(at workoutBlueprint: WorkoutBlueprint) {
        let dataStore = Firestore.firestore().collection("workoutBlueprint")
        let deletedWorkout = dataStore.document("id").delete() { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Workout successfully removed")
            }
            
        }
    }
    
    func getRecordedWorkouts() -> [RecordedWorkout] { //LOCAL STORAGE
        getRecordedWorkoutsAsData().map {
            do {
                let workout: RecordedWorkout = try JSONDecoder().decode(RecordedWorkout.self, from: $0)
                print("recoredWorkoutRetreived")
                return workout
            } catch {
                return nil
            }
        }.compactMap { $0 }
    }
    
//    func getWorkoutBlueprintsRemote(completion: @escaping ([WorkoutBlueprint]?, Error?) -> Void) { //FIREBASE
//        let dataStore = Firestore.firestore().collection("workoutBlueprint")
//
//        dataStore.getDocuments { queryCall, error in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(nil, error)
//            } else {
//                if let queryCall = queryCall {
//                    let workoutBlueprints = queryCall.documents.compactMap { document -> WorkoutBlueprint? in
//                        guard let name = document["name"] as? String,
//                              let warmup = document["warmup"] as? WorkoutPhase,
//                              let intervals = document["intervals"] as? IntervalCollection,
//                              let cooldown = document["cooldown"] as? WorkoutPhase else {
//                            return nil
//                        }
//                        return WorkoutBlueprint(name: name, warmup: warmup, intervals: intervals, cooldown: cooldown)
//                    }
//                    completion(workoutBlueprints, nil)
//                }
//            }
//        }
//    }
    
    func observeRecordedWorkouts() -> AnyPublisher<[RecordedWorkout], Never> {
        UserDefaults.standard.publisher(for: \.recordedWorkouts).map { dataList in
            dataList.map {
                try? JSONDecoder().decode(RecordedWorkout.self, from: $0)
            }.compactMap { $0 }
        }.eraseToAnyPublisher()
    }
    
    func observeWorkoutBlueprints() -> AnyPublisher<[WorkoutBlueprint], Never> {
        UserDefaults.standard.publisher(for: \.workoutBlueprints).map { dataList in
            dataList.map {
                try? JSONDecoder().decode(WorkoutBlueprint.self, from: $0)
            }.compactMap { $0 }
        }.eraseToAnyPublisher()
    }
    
    func deleteWorkoutBlueprint(at workoutBlueprint: WorkoutBlueprint) { //LOCAL STORAGE
        deleteWorkoutRemote(at:workoutBlueprint)
        //we want to delete the workout this already saved
      let oldList = getWorkoutBlueprints()
        // get list of all current saved workouts (getWorkoutBlueprints())
        // comepare every element in the array of Blueprints to one that we want to delete
        
        let newList = oldList.filter{ savedWorkoutBlueprint in
            workoutBlueprint.id != savedWorkoutBlueprint.id
        }
        // make a new list of the removed "filtered" list and assign that to the local data
        let newWorkoutBlueprintData: [Data] = newList.map {
            do {
                let data = try JSONEncoder().encode($0)
                return data
            } catch {
                print("Error updating list : \(error.localizedDescription)")
                return nil
            }
        }.compactMap{$0}
        UserDefaults.standard.workoutBlueprints = newWorkoutBlueprintData
    }
   
func getWorkoutBlueprintAsData() -> [Data] {
    UserDefaults.standard.workoutBlueprints
}
    

    func getRecordedWorkoutsAsData() -> [Data] {
        return []
    }
    
    func getRecordedWorkoutsRemote() {
        let dataStore = Firestore.firestore().collection("recordedWorkouts")
        dataStore.getDocuments { [weak self] queryCall, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let queryCall = queryCall {
                    let remoteWorkoutData:[Data] = queryCall.documents.compactMap { document in
                        Self.convertDictionaryToRecordedWorkout(dictionary: document.data())
                    }.map { recordeWorkout in
                        do {
                            return try JSONEncoder().encode(recordeWorkout)
                        } catch {
                            return nil
                        }
                    }.compactMap{
                        $0
                    }
    
                    UserDefaults.standard.recordedWorkouts = remoteWorkoutData
                }
            }
        }
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

extension UserDefaults {
    @objc var workoutBlueprints: [Data] {
        get {
            if let data = UserDefaults.standard.object(forKey: "workoutBlueprint") as? [Data] {
                return data
            } else {
                return []
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "workoutBlueprint")
        }
    }
    
    @objc var recordedWorkouts: [Data] {
        get {
            if let data = UserDefaults.standard.object(forKey: "recordedWorkouts") as? [Data] {
                return data
            } else {
                return []
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "recordedWorkouts")
        }
    }
}
extension DataStorageService {
    static func convertBlueprintToDictionary(blueprint:WorkoutBlueprint)-> [String: Any] { //converts workoutBlueprint into dictionary to save data to firebase
        ["id": blueprint.id,
         "name": blueprint.name,
         "warmup" : convertPhasesToDictionary(phase: blueprint.warmup),
         "intervals" : convertIntervalCollectionToDictionary(interval:blueprint.intervals),
         "cooldown" : convertPhasesToDictionary(phase: blueprint.cooldown)
         ]
        //my blueprint converted to a dictionary
    }
    
    static func convertIntervalCollectionToDictionary(interval: IntervalCollection)-> [String: Any] {
        [:]
    }
    
    static func convertPhasesToDictionary(phase: WorkoutPhase) -> [String:Any] {
        [:]
    }
    
    static func convertRecordedWorkoutToDictionary(recordedWorkout: RecordedWorkout)-> [String: Any] { //converts recordedWorkout into dictionary to save data to firebase
        [  "id": recordedWorkout.id,
           "name": recordedWorkout.name,
           "duration": recordedWorkout.duration,
           "date" : recordedWorkout.date,
        ]
    }
    
    static func convertDictionaryToRecordedWorkout(dictionary: [String: Any]) -> RecordedWorkout {
        guard let name = dictionary["name"] as? String,
              let duration = dictionary["duration"] as? Double,
              let date = dictionary["date"] as? Date else {
            return RecordedWorkout(name: "", duration: 0, date: Date())
        }
        return RecordedWorkout(name: name, duration: duration, date: date)
    }
    
    static func convertDictionaryToWorkoutBluePrint(dictionary: [String: Any]) -> WorkoutBlueprint {
        guard let name = dictionary["name"] as?  String,
              let warmup = dictionary["warmup"] as? WorkoutPhase,
              let intervals = dictionary["intervals"] as? IntervalCollection,
              let cooldown = dictionary["cooldown"] as? WorkoutPhase else {
            
            return WorkoutBlueprint(name: "", warmup: WorkoutPhase.warmUP, intervals: IntervalCollection.initial, cooldown: WorkoutPhase.coolDown)
        }
        return WorkoutBlueprint(name: name, warmup: warmup, intervals: intervals, cooldown: cooldown)
    }
}
