//
//  WorkoutListManager.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/4/22.
//

import Foundation
import SwiftUI

class WorkoutListViewModel: ObservableObject {
    @Published var workOuts: [Workout] = []
    private let service: DataStorageServiceIdentity
    init(service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        if let workout = service.getWorkout() {
            self.workOuts = [workout]
        }
    }
}

extension WorkoutListViewModel {
    func didSelectWorkout(workout:Workout) {
        
    }
    
    func didSelectAddWorkout(){
        
    }
}
