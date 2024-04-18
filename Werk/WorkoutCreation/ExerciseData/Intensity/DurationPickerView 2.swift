//
//  DurationPickerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 7/16/23.
//

import SwiftUI

struct DurationPickerView: View {
    @ObservedObject var viewModel = DurationPickerViewModel()
    
    var body: some View {
        HStack {
            Picker("Hours", selection: $viewModel.selectedHours) {
                ForEach(viewModel.hours) { hour in
                    Text(hour.label).tag(hour.value)
                }
            }
            .pickerStyle(.wheel)
            
            Picker("Minutes", selection: $viewModel.selectedMinutes) {
                ForEach(viewModel.minutes) { minute in
                    Text(minute.label).tag(minute.value)
                }
            }
            .pickerStyle(.wheel)
            
            Picker("Seconds", selection: $viewModel.selectedSeconds) {
                ForEach(viewModel.seconds) { second in
                    Text(second.label).tag(second.value)
                }
            }
            .pickerStyle(.wheel)
        }
        .padding()
    }
}
struct DurationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DurationPickerView()
    }
}
