//
//  WarmUpDetails.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/21/22.
//
import SwiftUI
import Foundation
import AVFoundation

struct WarmUpDetails: View {
    var viewModel = WorkoutCreationViewModel()
    var model = WarmUpViewModel()
    var soundModel = Audio()
    @State var pickerView = WarmUpPickerView()
    @State var bgColor =
    Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    
    
    
    var body: some View {
        NavigationView{
            Form {
                NavigationLink(destination: pickerView) {
                    Text("Duration")
                    
                }
                
                Button("Duration" ) {
                    
                    model.isPickerPresented.toggle()
                    
                }
                ColorPicker("Color", selection: $bgColor)
                Picker(selection: soundModel.$selectedSound,label: Text("Sound")) {
                    ForEach(soundModel.systemSounds, id: \.self) {
                        Text("\($0)")
                        
                    }
                }
            }.navigationTitle("Warm Up")
        }
        .sheet(isPresented: model.$isPickerPresented) {
            model.picker()
                .presentationDetents([.medium])
            
        }
    }
}



struct WarmUpView_Previews: PreviewProvider {
    static var previews: some View {
        WarmUpDetails()
    }
}


