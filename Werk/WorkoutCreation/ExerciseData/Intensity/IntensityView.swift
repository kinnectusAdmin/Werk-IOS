//
//  WarmUpDetails.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/21/22.
//
import SwiftUI
import AVFoundation
import Combine

struct IntensityView: View {

    @ObservedObject var viewModel: IntensityViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            Form {
                HStack {
                    Text("Duration")
                     Spacer()
                    //label for button to show duration picker
                    Button("\(viewModel.convertedTime)")
                    {    //action for button to show picker
                         viewModel.isPickerPresented.toggle()
                     }
                }
                ColorPicker("Color", selection: viewModel.$color)
            }.navigationTitle(viewModel.title)
        }
        .sheet(isPresented: isPickerPresentedBinding()) {
            IntensityPickerView(hours: $viewModel.workoutPhase.hours, minutes: $viewModel.workoutPhase.minutes, seconds: $viewModel.workoutPhase.seconds)
        
        }
        .onDisappear(perform: viewModel.didDisappear)

    }
    
    
    
    func isPickerPresentedBinding() -> Binding<Bool> {
        Binding(get: {
            viewModel.isPickerPresented
        }, set: { newValue in
            viewModel.isPickerPresented = newValue
        })
    }
}

struct IntensityView_Previews: PreviewProvider {
    static var previews: some View {
        IntensityView(viewModel: IntensityViewModel(workoutPhase: .coolDown, intensity: .warmup, updateFunction: {_ in }))
    }
}


