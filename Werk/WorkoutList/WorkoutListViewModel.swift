//
//  WorkoutListManager.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/4/22.
//

import Foundation
import SwiftUI

class WorkoutListViewModel: ObservableObject {
    @Published var workOuts: [WorkoutTemplate]
    init(workOuts: [WorkoutTemplate]) {
        self.workOuts = workOuts
    }
}

extension WorkoutListViewModel {
    func didSelectWorkout(workout:WorkoutTemplate) {
        
    }
    
    func didSelectAddWorkout(){
        
    }
}
