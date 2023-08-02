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
    @Published var isPickerPresented: Bool = false
    @State var color: Color = .blue

    
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
        }
    }
    
    var convertedTime:String { //shows String in 00:00 format
        return String(format: "%02d:%02d", (workoutPhase.minutes),(workoutPhase.seconds))
    }
//    var convertedMinutes:String { //shows String in 00:00 format
//        return String(format: "%02d", (workoutPhase.minutes))
//    }
//    var convertedSeconds:String { //shows String in 00:00 format
//        return String(format: "%02d", (workoutPhase.seconds))
//    }
    
    
    private var updateFunction: (WorkoutPhase) -> Void
    init(workoutPhase: WorkoutPhase, intensity: Intensity, updateFunction: @escaping (WorkoutPhase) -> Void) {
        self.currentIntensity = intensity
        self.workoutPhase = workoutPhase
        self.updateFunction = updateFunction
    }
}

enum Intensity {
    case warmup
    case lowIntensity
    case highIntensity
    case coolDown
}
extension IntensityViewModel {
    
    func didDisappear() {
        updateFunction(workoutPhase)
    }
}


