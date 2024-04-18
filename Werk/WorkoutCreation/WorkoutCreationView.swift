//
//  WorkoutEditView.swift
//  Werk
//
//  Created by Shaquil Campbell on 4/20/23.
//



import Foundation
import SwiftUI



struct WorkoutCreationEditViewForm: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutCreationEditViewModel
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    HStack {
                        //Text field to name workout and select its color to appear on graph
                        TextField("Workout Name",text: viewModel.workoutNameBinding)
                            .keyboardType(.alphabet)
                        Picker("", selection: $viewModel.selectedColorIndex) {
                            ForEach(0..<12) { index in
                                Text(viewModel.colors[index].description)
                            }
                        }
                    }
                }
                NavigationLink {
                    //takes user to warm up intensity set up
                    IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.didUpdateWarmupBinding(), intensity: .warmup))
                } label: {
                    HStack {
                        Text("Warm Up")
                        Spacer()
                        Text("\(viewModel.warmupDuration)")
                    }
                }
                
                ForEach(viewModel.workout.intervals.cycles, id: \.id) { cycle in
                    Section {
                        NavigationLink(destination: IntervalView(viewModel: IntervalViewModel(interval: viewModel.didUpdateIntervalBinding(interval: cycle)))) {
                            HStack {
                                Text("Interval Cycle")
                                Spacer()
                                Text(viewModel.numberOfSetsText(cycle))
                            }
                        }
                    }
                }
                
                Section {
                    Button("Add Cycle") {
                        viewModel.didSelectAddNewCycle()
                        
                        if viewModel.workout.intervals.cycles.count > 1 {
                            viewModel.showRestBetweenCycles = true
                        }
                    }
                }
                
                if viewModel.showRestBetweenCycles {
                    Section {
                        NavigationLink(destination: IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.didUpdateRestBinding(), intensity: .restBetweenPhases))) {
                            HStack {
                                Text("Rest Between Cycles")
                                Spacer()
                                Text("\(viewModel.restBetweenPhasesDuration)")
                            }
                        }
                    }
                }
                
                
                Section {
                    NavigationLink {
                        
                        IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.didUpdateCoolDownBinding(), intensity: .coolDown))
                    } label: {
                        HStack {
                            Text("Cool Down")
                            Spacer()
                            Text("\(viewModel.cooldownDuration)")
                        }
                    }
                    
                }
            }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Save") {
                                    viewModel.didSelectSave()
                                    self.presentationMode.wrappedValue.dismiss()
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
        WorkoutCreationEditViewForm(
            viewModel: WorkoutCreationEditViewModel(workout: WorkoutBlueprint.initial()))
    }
}



