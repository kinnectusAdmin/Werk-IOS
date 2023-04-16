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

    @ObservedObject var viewModel: IntensityViewModel
    @State var soundModel = Audio()
    @State var isPickerPresented: Bool = false
    @State var isSoundPickerPresented: Bool = false
    @State var color: Color = .blue
    init(viewModel: IntensityViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView{
            Form {
                HStack {
                    Text("Duration")
                    Spacer()
                    Button("\(viewModel.workoutPhase.hours):\(viewModel.workoutPhase.minutes):\(viewModel.workoutPhase.seconds)") {
                        isPickerPresented.toggle()
                    }
                }
                ColorPicker("Color", selection: $color)
                HStack {
                    Button("Sound"){
                        AudioServicesPlaySystemSound(SystemSoundID(viewModel.workoutPhase.sound.rawValue))
                    }
                    Spacer()
                    Button("Sound"){
                        isSoundPickerPresented.toggle()
                    }
                }
            }.navigationTitle(viewModel.title)
        }
        .sheet(isPresented: $isPickerPresented) {
            IntensityPickerView(hours: $viewModel.workoutPhase.hours,
                                minutes: $viewModel.workoutPhase.minutes,
                                seconds: $viewModel.workoutPhase.seconds)
                                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isSoundPickerPresented) {
            SoundPickerView().presentationDetents([.medium])
        }
        .onDisappear(perform: viewModel.didDisappear)

    }
    
    
    
    func isPickerPresentedBinding() -> Binding<Bool> {
        Binding(get: {
            isPickerPresented
        }, set: { newValue in
            isPickerPresented = newValue
        })
    }
}

struct IntensityView_Previews: PreviewProvider {
    static var previews: some View {
        IntensityView(viewModel: IntensityViewModel(workoutPhase: .coolDown, intensity: .warmup, updateFunction: {_ in }))
    }
}


