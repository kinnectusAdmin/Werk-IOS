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
        service.observeWorkoutBlueprints().assign(to: &$workOuts)
    }
    
    func deleteWorkout(at workOut: WorkoutBlueprint) {
       workOuts = workOuts.filter { bluePrint in
            bluePrint.id != workOut.id
        }
        service.deleteWorkoutBlueprint(at: workOut)
    }
}

extension WorkoutListViewModel {
    func didSelectWorkout() -> any View  {
        //when called this function should take a workoutBlueprint from the list in the workoutListView and navigate to the timer view that uses the selected workoutblueprint as a workoutBlock for the timer
        //do i have to convert a workout blueprint into a workout block?
        return NavigationLink(destination: TimerView(viewModel: TimerViewModel(workout: workOuts[4]))) {
            Text("")
        }
    }
    
    
    func didSelectAddworkout()-> any View {
        //displayes workout inital workout creation page
       return NavigationLink(destination: WorkoutCreationEditViewForm(viewModel: WorkoutCreationEditViewModel())) {
               EmptyView()
           }
    }
}
