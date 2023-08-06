//
//  IntervalDetails.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/22/22.
//
//
//  WarmUpDetails.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/21/22.
//
import SwiftUI
import Foundation
import AVFoundation

struct IntervalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: IntervalViewModel = IntervalViewModel(interval: .constant(.initial))
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    HStack(alignment: .bottom) {
                        Picker("Number of sets", selection: viewModel.numberOfsetsBinding) {
                            ForEach(0 ..< 100) {
                                Text("\($0)")
                            }
                        }.frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                Section {
                    List {
                        ForEach(viewModel.phases) { phase in
                            HStack{
                                Text("\(phase.name)")
                                Spacer()
                                Button(durationOfWorkout(duration: phase.duration.double)) {
                                    viewModel.didTogglePhaseDuration(phase.id)
                                }
                            }
                        }.onMove(perform: viewModel.move)
                            .environment(\.editMode, $viewModel.editMode)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isPickerPresented) {
            IntervalPicker(phase: viewModel.selectedPhaseBinding)
        }
    }
    
    func isPickerPresentedBinding() -> Binding<Bool> {
        Binding(get: {
            viewModel.isPickerPresented
        }, set: { newValue in
            viewModel.isPickerPresented = newValue
        })
    }
}



struct IntervalView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalView(viewModel: IntervalViewModel(interval: .constant(.initial)))
    }
}

