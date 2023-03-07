//
//  WarmUpPickerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import SwiftUI

struct WarmUpPickerView: View {
//    @Binding var show: Bool
    
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    
    var body: some View {
        HStack(alignment: .bottom) {
            Picker("", selection: $hours){
                ForEach(0..<24, id: \.self) { i in
                    Text("\(i) hr").tag(i)
                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: $minutes){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i) min").tag(i)
                }
            }.pickerStyle(WheelPickerStyle())
            Picker("", selection: $seconds){
                ForEach(0..<60, id: \.self) { i in
                    Text("\(i) sec").tag(i)
                }
            }.pickerStyle(WheelPickerStyle())
        }.padding(.horizontal)
    }
}

struct WarmUpPickerView_Previews: PreviewProvider {
    static var previews: some View {
        WarmUpPickerView()
    }
}




//static var columns = [
//    DurationPicker.Column(label: "hr", options: Array(0...24).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//    DurationPicker.Column(label: "min", options: Array(0...60).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//    DurationPicker.Column(label: "sec", options: Array(0...60).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//]
//
//static var selection1: Int = 0
//static var selection2: Int = 0
//static var selection3: Int = 0
//
//static var previews: some View {
//    DurationPicker(columns: columns, selections: [.constant(selection1), .constant(selection2), .constant(selection3)]).frame(height: 300).previewLayout(.sizeThatFits)
//}
