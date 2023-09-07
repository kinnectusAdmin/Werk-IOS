//
//  IntervalPicker.swift
//  Werk
//
//  Created by Shaquil Campbell on 7/16/23.
//

import SwiftUI

struct IntervalPicker: View {
    @Binding var phase: WorkoutPhase

    var body: some View {
        VStack {
            Text(phase.name)
                .font(Font.title)
  
            HStack {
                Text("Current Duration: ")
                    
                Text(durationOfWorkout(duration:phase.duration.double))
            }
            Spacer().frame(height: 50)
            HStack(alignment: .bottom) {
                Picker("", selection: _phase.hours){
                    ForEach(0..<24, id: \.self) { i in
                        Text("\(i) hr").tag(i)
                    }
                }.pickerStyle(WheelPickerStyle())
                Picker("", selection: _phase.minutes){
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) min").tag(i)
                    }
                }.pickerStyle(WheelPickerStyle())
                Picker("", selection: _phase.seconds){
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) sec").tag(i)
                    }
                }.pickerStyle(WheelPickerStyle())
            }.padding(.horizontal)
        }
    }
}

struct IntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        IntervalPicker(phase: .constant(.lowIntensitiy))
    }
}
