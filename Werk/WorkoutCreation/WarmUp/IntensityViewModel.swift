//
//  WarmUpViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import Foundation
import SwiftUI
import Combine

class IntensityViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published private var currentIntensity: Intensity
    @Published var workoutPhase: WorkoutPhase
    
    var title: String {
        switch currentIntensity {
        case .warmup:
            return "Warm UP"
            
        case .lowIntensity:
            return "Low Intensity"
            
        case .highIntensity:
            return "High Intensity"
            
        case .coolDown:
            return "Cool Down"
        }
    }
    private var updateFunction: (WorkoutPhase) -> Void
    init(workoutPhase: WorkoutPhase, intensity: Intensity, updateFunction: @escaping (WorkoutPhase) -> Void) {
        self.currentIntensity = intensity
        self.workoutPhase = workoutPhase
        self.updateFunction = updateFunction
    }
}

extension IntensityViewModel {
    enum Intensity {
        case warmup
        case lowIntensity
        case highIntensity
        case coolDown
    }
    
    func didDisappear() {
        updateFunction(workoutPhase)
    }
}

