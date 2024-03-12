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
    @ObservedObject var viewModel = IntervalViewModel(interval: .constant(Interval.initial()))  //cause of interval part of blueprint not being saved?
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    HStack(alignment: .bottom) {
                        //Button that dispalys option to choose # of sets
                        Picker("Number of sets", selection: viewModel.numberOfsetsBinding) {
                            ForEach(0 ..< 100) {
                                Text("\($0)")
                            }
                        }.frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                Section {
                    List {
                        ForEach(viewModel.phases, id: \.self) { phase in
                            HStack{
                                Text("\(phase.name)")
                                Spacer()
                                Button(durationOfWorkout(duration: phase.duration.double)) {
                                    viewModel.didTogglePhaseDuration(phase.id)
                                }
                            }
                        }.onMove(perform: viewModel.move)
                    }
                }
            }
            .toolbar {
                EditButton()
            }
        }
        .sheet(isPresented: $viewModel.isPickerPresented) {
            IntervalPicker(phase: viewModel.selectedPhaseBinding)
        }
    }
    
}


struct IntervalView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalView(viewModel: IntervalViewModel(interval: .constant(Interval.initial())))
    }
}
