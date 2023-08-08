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
    var interval: Binding<Interval> = .constant(Interval.initial())
    @Published var isPickerPresented: Bool = false
    var phases: [WorkoutPhase] = []
    @State var editMode: EditMode = .active
    private var selectedPhaseID: String = ""
    
    var selectedPhaseBinding: Binding<WorkoutPhase> {
        Binding<WorkoutPhase>.init(get: getSelectedWorkoutPhase, set: setSelectedWorkoutPhase)
    }
    
    var numberOfsetsBinding: Binding<Int> {
        interval.numberOfSets
    }
    
    init(interval: Binding<Interval>) {
        self.interval = interval
        self.phases = [self.interval.wrappedValue.lowIntensity, self.interval.wrappedValue.highIntensity]
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
        if phases.first?.id == interval.wrappedValue.lowIntensity.id {
            interval.wrappedValue.order = .startsWithLowIntensity
        } else {
            interval.wrappedValue.order = .startsWithHighIntensity
        }
    }
    
    func didTogglePhaseDuration(_ phaseId: String) {
        selectedPhaseID = phaseId
        isPickerPresented = true
    }
}

extension Binding {
    func map<T>(fx: @escaping (Value) -> T, tx: @escaping (T) -> Void ) -> Binding<T> {
        Binding<T>.init {
            fx(self.wrappedValue)
        } set: { t in
            tx(t)
        }

    }
}
