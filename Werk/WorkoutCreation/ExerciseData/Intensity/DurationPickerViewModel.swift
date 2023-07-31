//
//  DurationPickerModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 7/16/23.
//

import Foundation

struct DurationComponents: Identifiable {
    let id = UUID()
    let value: Int
    let label: String
}

class DurationPickerViewModel: ObservableObject {
    @Published var selectedHours = 0
    @Published var selectedMinutes = 0
    @Published var selectedSeconds = 0
    
    let hours = Array(0...23).map { DurationComponents(value: $0, label: String(format: "%02dhr", $0)) }
    let minutes = Array(0...59).map { DurationComponents(value: $0, label: String(format: "%02dmin", $0)) }
    let seconds = Array(0...59).map { DurationComponents(value: $0, label: String(format: "%02dsec", $0)) }
    
    var selectedTime: String {
        return String(format: "%02dhr %02dmin %02dsec", selectedHours, selectedMinutes, selectedSeconds)
    }
}
