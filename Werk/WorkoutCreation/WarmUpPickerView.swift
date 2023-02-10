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
        HStack {
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
