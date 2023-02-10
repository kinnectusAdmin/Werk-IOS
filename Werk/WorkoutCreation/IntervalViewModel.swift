//
//  IntervalViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 1/16/23.
//

import Foundation
import SwiftUI


class IntervalViewModel: Identifiable, ObservableObject {
        var phases = [WorkoutPhase.lowIntensitiy, WorkoutPhase.highItensitity]
        //^ Arrary to make sortable list
    @State var numberOfsets = 1
    @State var editMode: EditMode = .active
        
    
    
}

extension IntervalViewModel {
    func move(indicies: IndexSet, newOffset: Int) {
        phases.move(fromOffsets: indicies, toOffset: newOffset)
    }
}
