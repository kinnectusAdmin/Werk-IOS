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
    func saveRecordedWorkoutRemote(recordedWorkout: RecordedWorkout)
    func getRecordedWorkouts() -> [RecordedWorkout]
    func getRecordedWorkoutsRemote()
    func observeWorkoutBlueprints() -> AnyPublisher<[WorkoutBlueprint], Never>
    func observeRecordedWorkouts() -> AnyPublisher<[RecordedWorkout], Never>
    func deleteWorkoutBlueprint(at workoutBlueprint: WorkoutBlueprint)
    func getLocalCurrentUser() -> UserModel?
    
}

enum DataKey: String {
    case workoutBlueprint
    case recordedWorkouts
    case userId
}

class DataStorageService: DataStorageServiceIdentity {
    
    
    func saveWorkoutBlueprint(workoutBlueprint: WorkoutBlueprint) { //LOCAL STORAGE
        
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
    
    func saveWorkoutBlueprintRemote(workoutBlueprint: WorkoutBlueprint) { //REMOTE STORAGE
        var copy = workoutBlueprint
        let dataStore = Firestore.firestore().collection(DataKey.workoutBlueprint.rawValue)
        //whenever I want to create an instance of a data base use fireStore.Firetore().collection
        
        let documents = dataStore.document()
        copy.id = documents.documentID
        documents.setData(DataStorageService.convertBlueprintToDictionary(blueprint: copy)) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Did save workout")
                
                self?.saveWorkoutBlueprint(workoutBlueprint: copy)
            }
        }
        //stores my workout
    }
    
    func getWorkoutBlueprints() -> [WorkoutBlueprint] { //RETREIVES WORKOUT BLUEPRINT
        getWorkoutBlueprintAsData().map {
            do {
                let blueprint: WorkoutBlueprint = try JSONDecoder().decode(WorkoutBlueprint.self, from: $0)
                return blueprint
            } catch {
                return nil
            }
        }.compactMap{$0}
    }
    
    
    
    func getWorkoutBlueprintsRemote(){ //FIREBASE
        guard let user = getLocalCurrentUser() else { return }
        let dataStore = Firestore.firestore().collection(DataKey.workoutBlueprint.rawValue).whereField("userId", isEqualTo: user.id)
        dataStore.getDocuments { queryCall, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let queryCall = queryCall {
                    let remoteWorkoutBlueprints = queryCall.documents.compactMap { w -> WorkoutBlueprint? in
                        guard let userId = w["userId"] as? String else { return nil}
                        let id = w["id"] as? String ?? ""
                        let name = w["name"] as?  String ?? ""
                        let warmup = Self.convertDictionaryToWorkPhase(dictionary: (w["warmup"] as? [String: Any] ?? [:]))
                        let intervals = Self.convertDictionaryToIntervaCollectionl(dictionary:(w["intervals"] as? [String: Any]) ?? [:])
                        let cooldown = Self.convertDictionaryToWorkPhase(dictionary: w["cooldown"] as? [String: Any] ?? [:])
                        print("returned workout")
                        return WorkoutBlueprint(userId: userId, id: id , name: name, warmup: warmup, intervals: intervals, cooldown: cooldown)
                    }
                    let blueprintData: [Data] = remoteWorkoutBlueprints.map { blueprint -> Data? in
                        do {
                            return try JSONEncoder().encode(blueprint)
                        } catch {
                            return nil
                        }
                    }.compactMap { $0}
                    
                    
                    UserDefaults.standard.workoutBlueprints = blueprintData
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
                UserDefaults.standard.set(newWorkoutData, forKey: DataKey.recordedWorkouts.rawValue)
            } else {
                let newWorkoutData = try JSONEncoder().encode(recordedWorkout)
                let allWorkoutData = getRecordedWorkoutsAsData().appending(newWorkoutData)
                UserDefaults.standard.set(allWorkoutData, forKey: DataKey.recordedWorkouts.rawValue)
            }
        } catch {
            print("Error saving RecordedWorkout: \(error.localizedDescription)")
        }
    }
    
    func saveRecordedWorkoutRemote(recordedWorkout: RecordedWorkout) { //FIREBASE
        var copy = recordedWorkout
        let dataStore = Firestore.firestore().collection(DataKey.recordedWorkouts.rawValue)
        
        let document = dataStore.document()
        copy.id = document.documentID
        document.setData(DataStorageService.convertRecordedWorkoutToDictionary(recordedWorkout: copy)) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Did save recorded workout")
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
    
    func observeRecordedWorkouts() -> AnyPublisher<[RecordedWorkout], Never> {
        UserDefaults.standard.publisher(for: \.recordedWorkouts).map { dataList in
            dataList.map {
                do {
                return try JSONDecoder().decode(RecordedWorkout.self, from: $0)
                } catch {
                    return nil
                }
            }.compactMap { $0 }
        }.eraseToAnyPublisher()
    }
    
    func observeWorkoutBlueprints() -> AnyPublisher<[WorkoutBlueprint], Never> {
        UserDefaults.standard.publisher(for: \.workoutBlueprints).map { dataList in
            dataList.map {
                do {
                    return try JSONDecoder().decode(WorkoutBlueprint.self, from: $0)
                } catch {
                    return nil
                }
            }.compactMap { $0 }
        }.eraseToAnyPublisher()
    }
    
    
    func deleteWorkoutBlueprint(at workoutBlueprint: WorkoutBlueprint) {
        deleteWorkoutBlueprintRemote(at: workoutBlueprint)
        let oldList = UserDefaults.standard.workoutBlueprints.map {
            try! JSONDecoder().decode(WorkoutBlueprint.self, from: $0)
        }
        let newList = oldList.filter { savedWorkoutBlueprint in
            workoutBlueprint.id != savedWorkoutBlueprint.id
        }
        let newWorkoutBlueprintData: [Data] = newList.map {
            do {
                let data = try JSONEncoder().encode($0)
                return data
            } catch {
                print("Error updating list : \(error.localizedDescription)")
                return nil
            }
        }.compactMap { $0 }
        UserDefaults.standard.workoutBlueprints = newWorkoutBlueprintData
    }
        
        //    func saveRecordedWorkoutsRemote(recordedWorkout: RecordedWorkout) { //FIREBASE
        //        var copy = recordedWorkout
        //        let dataStore = Firestore.firestore().collection(DataKey.recordedWorkouts.rawValue)
        //
        //        let document = dataStore.document()
        //        copy.id = document.documentID
        //        document.setData(DataStorageService.convertRecordedWorkoutToDictionary(recordedWorkout: recordedWorkout)) { error in
        //            if let error = error {
        //                print(error.localizedDescription)
        //            } else {
        //                print("Did save recorded workout")
        //            }
        //        }
        //    }
    func deleteWorkoutBlueprintRemote(at workoutBlueprint: WorkoutBlueprint) {
      Firestore.firestore().collection("workoutBlueprint").document(workoutBlueprint.id).delete() { error in
            //when deleted the document by name given by firebase the document is removed.  when deleting it by ID the workout is not deleted
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Workout successfully removed")
            }
        }
    }
    
    
    

    func getWorkoutBlueprintAsData() -> [Data] {
        UserDefaults.standard.workoutBlueprints
    }
    
    
    func getRecordedWorkoutsAsData() -> [Data] {
        UserDefaults.standard.recordedWorkouts
    }
    
//    static func convertDictionaryToRecordedWorkout(dictionary: [String: Any]) -> RecordedWorkout {
//        guard let userId = dictionary["userId"] as? String,
//              let name = dictionary["name"] as? String,
//              let duration = dictionary["duration"] as? Double,
//              let date = dictionary["date"] as? Date else {
//            return RecordedWorkout(userId: "",name: "", duration: 0, date: Date())
//        }
//        return RecordedWorkout(userId: userId, name: name, duration: duration, date: date)
//    }
    
    func getRecordedWorkoutsRemote() {
        guard let user = getLocalCurrentUser() else { return }
        let dataStore = Firestore.firestore().collection("recordedWorkouts").whereField("userId", isEqualTo: user.id)
        dataStore.getDocuments { queryCall, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let queryCall = queryCall {
                    let remoteWorkoutData:[Data] = queryCall.documents.compactMap { document in
                        Self.convertDictionaryToRecordedWorkout(dictionary: document.data())
                    }.map { recordedWorkout in
                        do {
                            return try JSONEncoder().encode(recordedWorkout)
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
    
    
    func getLocalCurrentUser() -> UserModel?{
        let data = UserDefaults.standard.userData
        return try? JSONDecoder().decode(UserModel.self, from: data)
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
    
    @objc var userData: Data {
        get {
            if let data = UserDefaults.standard.object(forKey: DataKey.userId.rawValue) as? Data {
                return data
            } else {
                return Data()
            }
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: DataKey.userId.rawValue)
        }
    }
    
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
        [
            "userId": blueprint.userId,
            "id": blueprint.id,
            "name": blueprint.name,
            "warmup" : convertPhasesToDictionary(phase: blueprint.warmup),
            "intervals" : convertIntervalCollectionToDictionary(interval:blueprint.intervals),
            "cooldown" : convertPhasesToDictionary(phase: blueprint.cooldown)
        ]
        //my blueprint converted to a dictionary
    }
    
    static func convertIntervalCollectionToDictionary(interval: IntervalCollection)-> [String: Any] {
        [
            "_cycles": interval._cycles.map { convertIntervalToDictionary(interval: $0) },
            "restBetweenPhases": convertPhasesToDictionary(phase: interval.restBetweenPhases)
        ]
    }
    
    static func convertDictionaryToIntervaCollectionl(dictionary: [String:Any])-> IntervalCollection {
        guard let _cycles = dictionary["_cycles"] as? [Interval],
              let restBetweenPhases = dictionary["restBetweenPhases"] as? WorkoutPhase else{
            return IntervalCollection(_cycles: [], restBetweenPhases: .restBetweenPhases)
        }
        return IntervalCollection(_cycles: _cycles, restBetweenPhases: restBetweenPhases)
    }
    static func convertIntervalToDictionary(interval: Interval) -> [String : Any] {
        [ "id": interval.id,
          "highIntensity": convertPhasesToDictionary(phase: interval.highIntensity),
          "lowIntensity": convertPhasesToDictionary(phase: interval.lowIntensity),
          "numberOfSets": interval.numberOfSets,
          "order": interval.order.rawValue,
          "restPhase": interval.restPhase == nil ? nil : convertPhasesToDictionary(phase: interval.restPhase!)
        ]
    }
    static func convertPhasesToDictionary(phase: WorkoutPhase) -> [String: Any] {
        [
            "id": phase.id,
            "name": phase.name,
            "hours": phase.hours,
            "minutes": phase.minutes,
            "seconds": phase.seconds
        ]
    }
    
    static func convertDictionaryToWorkPhase(dictionary: [String:Any]) -> WorkoutPhase {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let hours = dictionary["hours"] as? Int,
              let minutes = dictionary["minutes"] as? Int,
              let seconds = dictionary["seconds"] as? Int else {
            return WorkoutPhase(id: "", name: "")
        }
        return WorkoutPhase(id: id, name: name, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    
    static func convertRecordedWorkoutToDictionary(recordedWorkout: RecordedWorkout)-> [String: Any] { //converts recordedWorkout into dictionary to save data to firebase
        [
            "userId": recordedWorkout.userId,
            "workoutId": recordedWorkout.id,
            "name": recordedWorkout.name,
            "duration": recordedWorkout.duration,
            "date" : recordedWorkout.date,
        ]
    }
    
    static func convertDictionaryToRecordedWorkout(dictionary: [String: Any]) -> RecordedWorkout {
        guard let userId = dictionary["userId"] as? String,
              let name = dictionary["name"] as? String,
              let duration = dictionary["duration"] as? Double,
              let date = dictionary["date"] as? Date else {
            return RecordedWorkout(userId: "",name: "", duration: 0, date: Date())
        }
        return RecordedWorkout(userId: userId, name: name, duration: duration, date: date)
    }
    
//    static func convertDictionaryToWorkoutBluePrint(dictionary: [String: Any]) -> WorkoutBlueprint {
//        guard let userId = dictionary["userId"] as? String,
//              let name = dictionary["name"] as?  String,
//              let warmup = dictionary["warmup"] as? WorkoutPhase,
//              let intervals = dictionary["intervals"] as? IntervalCollection,
//              let cooldown = dictionary["cooldown"] as? WorkoutPhase else {
//            
//            return WorkoutBlueprint(userId: "", name: "", warmup: WorkoutPhase.warmUP, intervals: IntervalCollection.initial, cooldown: WorkoutPhase.coolDown)
//        }
//        return WorkoutBlueprint(userId: userId, name: name, warmup: warmup, intervals: intervals, cooldown: cooldown)
//    }
}
