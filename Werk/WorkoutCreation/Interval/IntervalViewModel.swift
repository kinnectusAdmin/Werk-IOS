//
//  IntervalViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 1/16/23.
//

import Foundation
import SwiftUI
import Combine

class IntervalViewModel: ObservableObject, Identifiable {
    private var cancellables =  Set<AnyCancellable>()
    var interval: Binding<Interval>
    @Published var isPickerPresented: Bool = false
    @Published var phases: [WorkoutPhase] = []
//    @Published var editMode: EditMode = .active
    private var selectedPhaseID: String = ""
    
    var selectedPhaseBinding: Binding<WorkoutPhase> {
        //Binding to update selected workout phasse
        Binding<WorkoutPhase>.init(get: getSelectedWorkoutPhase, set: setSelectedWorkoutPhase)
    }
    
    var numberOfsetsBinding: Binding<Int> {
        //Binding to update number of sets
        interval.numberOfSets
    }
    
    init(interval: Binding<Interval>) {
        self.interval = interval
        if self.interval.wrappedValue.order  == .startsWithLowIntensity {
            self.phases = [self.interval.wrappedValue.lowIntensity, self.interval.wrappedValue.highIntensity]
        } else {
            self.phases = [self.interval.wrappedValue.highIntensity, self.interval.wrappedValue.lowIntensity]
        }
        print("Phases: \(phases.map { $0.name })")
    }
    
    private func getSelectedWorkoutPhase() -> WorkoutPhase {
        phases.filter { $0.id == selectedPhaseID }.first ?? .lowIntensity
    }
    
    private func setSelectedWorkoutPhase(updatedPhase: WorkoutPhase, transaction: Transaction) {
        phases = phases.map {
            $0.id == updatedPhase.id ? updatedPhase : $0
        }
        if updatedPhase.id == interval.highIntensity.id{
            interval.wrappedValue.highIntensity = phases.filter { $0.id == updatedPhase.id }.first!
        }
        if updatedPhase.id == interval.lowIntensity.id {
            interval.wrappedValue.lowIntensity = phases.filter { $0.id == updatedPhase.id}.first!
        }
    }
    
    func isPickerPresentedBinding() -> Binding<Bool> {
        Binding(get: {
            self.isPickerPresented
        }, set: { newValue in
            self.isPickerPresented = newValue
        })
    }
}

extension IntervalViewModel {
    func move(indicies: IndexSet, newOffset: Int) {
        phases.move(fromOffsets: indicies, toOffset: newOffset)
        if phases.first?.id == interval.wrappedValue.lowIntensity.id {
            interval.wrappedValue.order = .startsWithLowIntensity
            print("\(interval.order)")
        } else {
            interval.wrappedValue.order = .startsWithHighIntensity
            print("\(interval.order)")
        }
    }
    
    
//    func move(indices: IndexSet, newOffset: Int) {                 <-- test
//        phases.move(fromOffsets: indices, toOffset: newOffset)
//        print("Phases after move: \(phases.map { $0.name })")
//        
//        if let firstPhase = phases.first, let lastPhase = phases.last {
//            interval.wrappedValue.highIntensity = firstPhase
//            interval.wrappedValue.lowIntensity = lastPhase
//        }
//        forceUpdate()
//        print("Updated interval - High: \(interval.wrappedValue.highIntensity.name), Low: \(interval.wrappedValue.lowIntensity.name)")
//    }
// 
//    func forceUpdate() {
//        self.objectWillChange.send()
//    }
    
    
    
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
