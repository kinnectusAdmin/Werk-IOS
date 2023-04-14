//
//  WarmUpDetails.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/21/22.
//
import SwiftUI
import Foundation
import AVFoundation
import Combine

//class WarmUpViewModel: ObservableObject {
//    private var cancellables = Set<AnyCancellable>()
//    @Published var warmup: WorkoutPhase
//    init(warmup: WorkoutPhase, updateFunction: @escaping (WorkoutPhase) -> Void) {
//        self.warmup = warmup
//        $warmup.sink { warmup in
//            updateFunction(warmup)
//        }.store(in: &cancellables)
//    }
//}


struct IntensityView: View {
    @ObservedObject var viewModel: WarmUpViewModel
    @State var soundModel = Audio()
    @State var isPickerPresented: Bool = false
    @State var isSoundPickerPresented: Bool = false
    init(viewModel: WarmUpViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView{
            Form {
                
                HStack {
                   Text("Duration")
                    Spacer()
                    Button("\(viewModel.intensity.hours):\(viewModel.intensity.minutes):\(viewModel.intensity.seconds)") {
                        isPickerPresented.toggle()
                    }
                }
                ColorPicker("Color", selection: $viewModel.intensity.color)
                HStack {
                    Button("Sound"){
                        AudioServicesPlaySystemSound(SystemSoundID(viewModel.intensity.sound.rawValue))
                    }
                    Spacer()
                    Button("Sound"){
                        isSoundPickerPresented.toggle()
                    }
                }
            }.navigationTitle("Warm Up")
        }
        .sheet(isPresented: $isPickerPresented) {
            WarmUpPickerView(hours: $viewModel.intensity.hours, minutes: $viewModel.intensity.minutes, seconds: $viewModel.intensity.seconds)
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
        IntensityView(viewModel: WarmUpViewModel(intensity: .lowIntensitiy, updateFunction: {_ in }))
    }
}


