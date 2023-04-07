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

class WarmUpViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var warmup: WorkoutPhase
    init(warmup: WorkoutPhase, updateFunction: @escaping (WorkoutPhase) -> Void) {
        self.warmup = warmup
        $warmup.sink { warmup in
            updateFunction(warmup)
        }.store(in: &cancellables)
    }
}


struct WarmUpView: View {
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
                    Button("\(viewModel.warmup.hours):\(viewModel.warmup.minutes):\(viewModel.warmup.seconds)") {
                        isPickerPresented.toggle()
                    }
                }
                ColorPicker("Color", selection: $viewModel.warmup.color)
                HStack {
                    Button("Sound"){
                        AudioServicesPlaySystemSound(SystemSoundID(viewModel.warmup.sound.rawValue))
                    }
                    Spacer()
                    Button("Sound"){
                        isSoundPickerPresented.toggle()
                    }
                }
            }.navigationTitle("Warm Up")
        }
        .sheet(isPresented: $isPickerPresented) {
            WarmUpPickerView(hours: $viewModel.warmup.hours, minutes: $viewModel.warmup.minutes, seconds: $viewModel.warmup.seconds)
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
        WarmUpView(viewModel: WarmUpViewModel(warmup: .lowIntensitiy, updateFunction: {_ in }))
    }
}


