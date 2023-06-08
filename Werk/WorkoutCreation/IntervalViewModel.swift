//
//  IntervalViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 1/16/23.
//

import Foundation
import SwiftUI


class IntervalViewModel: ObservableObject {
      @Published  var phases = [WorkoutPhase.lowIntensitiy, WorkoutPhase.highItensitity]
        //^ Arrary to make sortable list
    @Published var numberOfsets = 0
    @State var editMode: EditMode = .active
    var numberOfsetsBinding: Binding<Int> {
        Binding<Int>.init {
            return self.numberOfsets
        } set: { numberOfSets in
            self.numberOfsets = numberOfSets
        }

    }
    
    
    
    
}

extension IntervalViewModel {
    func move(indicies: IndexSet, newOffset: Int) {
        phases.move(fromOffsets: indicies, toOffset: newOffset)
    }
}
