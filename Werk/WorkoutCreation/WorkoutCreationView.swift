//
//  WorkoutCreationView.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/8/22.
//

import Foundation
import SwiftUI





struct WorkoutCreationViewForm: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutCreationViewModel = WorkoutCreationViewModel()

    let colors:[Color] =
    [
        Color.red, Color.blue, Color.green, Color.indigo, Color.orange
    ]

    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    HStack {
                        
                        TextField("Timer Name",text: viewModel.workoutNameBinding)
                            .keyboardType(.alphabet)
                        Picker("", selection: $viewModel.selectedColorIndex) {
                            ForEach(0..<5) { index in
                                Text(colors[index].description)
                            }
                        }
                    }
                }
                NavigationLink {
                    IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.workout.warmup, intensity: .warmup, updateFunction: viewModel.didUpdateWarmup))
                } label: {
                    HStack {
                        Text("Warm Up")
                        Spacer()
                        Text("\(viewModel.warmupDuration)")
                    }
                }

                
                
                ForEach(viewModel.intervals.cycles, id: \.id) { cycle in
                    Section {
                        NavigationLink(destination: IntervalView()) {
                            HStack {
                                Text("Interval Cycle")
                                Spacer()
                                Text("\(cycle.numberOfSets) set")
                                
                            }
                        }
                        
                        NavigationLink {
                            IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.workout.highIntensity, intensity: .warmup, updateFunction: viewModel.didUpdateHighIntensity))
                        } label: {
                            HStack {
                                Text("High Intensity")
                                Spacer()
                                Text("\(viewModel.highIntensityDuration)")
                            }
                        }
                        NavigationLink {
                            IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.workout.lowIntensity, intensity: .lowIntensity, updateFunction: viewModel.didUpdateLowIntensity))
                        } label: {
                            HStack {
                                Text("Low Intensity")
                                Spacer()
                                Text("\(viewModel.lowIntensityDuration)")
                            }
                        }
                    }
                }
                
                Section {
                    Button("Add Cycle") {
                        
                        print("Print!")
                        viewModel.didSelectAddNewCycle()
                    }
                }
                //make a button that'll add a cycle to the view
                //check to make sure forms scroll automattically
                
                Section {
                    NavigationLink {
                        IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.workout.cooldown, intensity: .coolDown, updateFunction: viewModel.didUpdateCoolDown))
                    } label: {
                        HStack {
                            Text("Cool Down")
                            Spacer()
                            Text("\(viewModel.warmupDuration)")
                        }
                    }
                    
                }
            }.toolbar {   //this placement type bolds the item and places it on the top right of the screen
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.didSelectSave()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
}


struct WorkoutCreationViewForm_Previews: PreviewProvider {
    static var previews: some View{
        WorkoutCreationViewForm(
            viewModel: WorkoutCreationViewModel())
    }
}
