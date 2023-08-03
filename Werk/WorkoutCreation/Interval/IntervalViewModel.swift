//
//  IntervalViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 1/16/23.
//

import Foundation
import SwiftUI
import Combine

class IntervalViewModel: ObservableObject {
    private var cancellables =  Set<AnyCancellable>()
    @Published var interval: Interval = .initial
    @Published var isPickerPresented: Bool = false
    var phases: [WorkoutPhase] = []
    @State var editMode: EditMode = .active
    private var selectedPhaseID: String = ""
    var selectedPhaseBinding: Binding<WorkoutPhase> {
        Binding<WorkoutPhase>.init(get: getSelectedWorkoutPhase, set: setSelectedWorkoutPhase)
    }
    var numberOfsetsBinding: Binding<Int> {
        Binding<Int>.init {
            return self.interval.numberOfSets
        } set: { numberOfSets in
            self.interval.numberOfSets = numberOfSets
        }
    }
    
    init(interval: Interval, didUpdateInterval: @escaping (Interval) -> Void) {
        self.interval = interval
        self.phases = [interval.lowIntensity, interval.highIntensity]
        
        self.$interval.sink(receiveValue: didUpdateInterval).store(in: &cancellables)
    }
    
    private func getSelectedWorkoutPhase() -> WorkoutPhase {
        phases.filter { $0.id == selectedPhaseID }.first ?? .lowIntensitiy
    }
    private func setSelectedWorkoutPhase(updatedPhase: WorkoutPhase, transaction: Transaction) {
        phases = phases.map {
            $0.id == updatedPhase.id ? updatedPhase : $0
        }
    }
}

extension IntervalViewModel {
    func move(indicies: IndexSet, newOffset: Int) {
        phases.move(fromOffsets: indicies, toOffset: newOffset)
    }
    func didTogglePhaseDuration(_ phaseId: String) {
        selectedPhaseID = phaseId
        isPickerPresented = true
    }
}
