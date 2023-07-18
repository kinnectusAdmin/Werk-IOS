//
//  WarmUpPickerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import SwiftUI
import AVFoundation

struct IntensityPickerView: View {
    //    @Binding var show: Bool


    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int


    var body: some View {
        HStack(alignment: .bottom) {
            Picker("", selection: _hours){
                ForEach(0..<24, id: \.self) { i in
                    Text("\(i) hr").tag(i)
                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: _minutes){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i) min").tag(i)
                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: _seconds){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i) sec").tag(i)
                }
            }.pickerStyle(WheelPickerStyle())
        }.padding(.horizontal)
    }
}

struct WarmUpPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IntensityPickerView(hours: .constant(0), minutes: .constant(0), seconds: .constant(0))
    }
}




