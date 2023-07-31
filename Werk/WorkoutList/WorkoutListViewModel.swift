//
//  WorkoutListManager.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/4/22.
//

import Foundation
import SwiftUI

class WorkoutListViewModel: ObservableObject {
    @Published var workOuts: [WorkoutBlueprint] = []
    private let service: DataStorageServiceIdentity
    init(service: DataStorageServiceIdentity = DataStorageService()) {
        self.service = service
        if let workout = service.getWorkoutBlueprint() {
            self.workOuts = workout
        }
    }
}

extension WorkoutListViewModel {
    func didSelectWorkout(workout:WorkoutBlueprint) {
      
    }
    func didSelectAddworkout()-> any View {
        //displayes workout inital workout creation page
       return NavigationLink(destination: WorkoutCreationEditViewForm(viewModel: WorkoutCreationEditViewModel())) {
               EmptyView()
           }
    }
}
