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
//    @State var model = WarmUpViewModel()
    @State var soundModel = Audio()
    @State var isPickerPresented: Bool = false
    @State var isSoundPickerPresented: Bool = false
    @State var sound: Int = 1309
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var bgColor =
    Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

    var body: some View {
        NavigationView{
            Form {
                
                HStack {
                   Text("Duration")
                    Spacer()
                    Button("\(hours):\(minutes):\(seconds)") {
                        isPickerPresented.toggle()
                    }
                }
                ColorPicker("Color", selection: $bgColor)
                
                
                HStack {
                    Button("Sound"){
                        AudioServicesPlaySystemSound(SystemSoundID(sound))
                    }
                    Spacer()
                    Button("Sound"){
                        isSoundPickerPresented.toggle()
                    }
                }
                
                
                Picker(selection: soundModel.$selectedSound,label: Text("Sound")) {
                    ForEach(soundModel.systemSounds, id: \.self) {
                        Text("\($0)")
                        
                    }
                }
            }.navigationTitle("Warm Up")
        }
        .sheet(isPresented: $isPickerPresented) {
            WarmUpPickerView(hours: $hours, minutes: $minutes, seconds: $seconds)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isSoundPickerPresented) {
            SoundPickerView().presentationDetents([.medium])
        }
    }
    
    
    
    func isPickerPresentedBinding() -> Binding<Bool> {
        Binding(get: {
            isPickerPresented
        }, set: { newValue in
            isPickerPresented = newValue
        })
    }
}

struct WarmUpView_Previews: PreviewProvider {
    static var previews: some View {
        WarmUpDetails()
    }
}


