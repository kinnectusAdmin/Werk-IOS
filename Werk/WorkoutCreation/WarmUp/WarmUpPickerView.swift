//
//  WarmUpPickerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/5/23.
//

import SwiftUI

struct WarmUpPickerView: View {
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
        WarmUpPickerView(hours: .constant(0), minutes: .constant(0), seconds: .constant(0))
    }
}



//func picker() -> AnyView {
//    var columns = [
//        DurationPicker.Column(label: "h", options: Array(0...24).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//        DurationPicker.Column(label: "min", options: Array(0...60).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//        DurationPicker.Column(label: "sec", options: Array(0...60).map { DurationPicker.Column.Option(text: "\($0)", tag: $0) }),
//    ]
//
//    var selection1: Int = 0
//    var selection2: Int = 0
//    var selection3: Int = 0
//
//    return AnyView(DurationPicker(columns: columns, selections: [.constant(selection1), .constant(selection2), .constant(selection3)]).frame(height: 300, alignment: .bottom).previewLayout(.sizeThatFits))
//}
//
//
//}
import AVFoundation

struct SoundPickerView: View {
    var systemSounds: [Int] = [1304,1307,1308,1309,1310]
    @State var sound: Int = 1304
    var body: some View {
        HStack(alignment: .bottom) {
            Picker("", selection: $sound) {
                ForEach(systemSounds, id: \.self) { i in
                    Button {
                        AudioServicesPlaySystemSound(SystemSoundID(i))
                    } label: {
                        Text("Sound \(i)").tag(i)
                    }
                }
            }.pickerStyle(WheelPickerStyle())
        }.padding(.horizontal)
    }
}
