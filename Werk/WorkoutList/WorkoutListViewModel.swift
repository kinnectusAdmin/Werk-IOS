//
//  WorkoutListManager.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/4/22.
//

import Foundation
import SwiftUI

class WorkoutListViewModel: ObservableObject {
    @Published var workOuts: [Workout]
    init(workOuts: [Workout]) {
        self.workOuts = workOuts
    }
}

extension WorkoutListViewModel {
    func didSelectWorkout(workout:Workout) {
        
    }
    
    func didSelectAddWorkout(){
        
    }
}
