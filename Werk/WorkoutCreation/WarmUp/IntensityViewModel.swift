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
    @Published var intensity: WorkoutPhase
    init(intensity: WorkoutPhase, updateFunction: @escaping (WorkoutPhase) -> Void) {
        self.intensity = intensity
        $intensity.sink { intensity in
            updateFunction(intensity)
        }.store(in: &cancellables)
    }
}


