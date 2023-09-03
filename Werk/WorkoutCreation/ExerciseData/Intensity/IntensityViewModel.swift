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
    @Binding var workoutPhase: WorkoutPhase
    @Published var isPickerPresented: Bool = false
    

    
    var title: String {
        switch currentIntensity {
        case .warmup:
            return "Warm Up"
            
        case .lowIntensity:
            return "Low Intensity"
            
        case .highIntensity:
            return "High Intensity"
            
        case .coolDown:
            return "Cool Down"
            
        case .restBetweenPhases:
            return "Rest"
        }
    }
    
    var convertedTime:String { //shows String in 00:00 format
        return String(format: "%02d:%02d:%02d", (workoutPhase.hours),(workoutPhase.minutes),(workoutPhase.seconds))
    }
    
//    private var updateFunction: (WorkoutPhase) -> Void
    init(workoutPhase: Binding<WorkoutPhase>, intensity: Intensity) {
        self.currentIntensity = intensity
        self._workoutPhase = workoutPhase
         
    }
}

enum Intensity: Codable {
    case warmup
    case lowIntensity
    case highIntensity
    case coolDown
    case restBetweenPhases
}
extension IntensityViewModel {
    
    func didDisappear() {
//        updateFunction(workoutPhase)
    }
}


