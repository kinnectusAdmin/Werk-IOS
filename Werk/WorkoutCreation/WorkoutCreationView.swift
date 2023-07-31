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
    init(viewModel: WorkoutCreationEditViewModel) {

        self.viewModel = viewModel
    }
    let colors:[Color] =
    [
        Color.red, Color.blue, Color.green, Color.indigo, Color.orange
    ]
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section {
                        HStack {
                            //Text field to name workout and select its color to appear on graph
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
                        //takes user to warm up intensity set up
                        IntensityView(viewModel: IntensityViewModel(workoutPhase: viewModel.workout.warmup, intensity: .warmup, updateFunction: viewModel.didUpdateWarmup))
                    } label: {
                        HStack {
                            Text("Warm Up")
                            Spacer()
                            Text("\(viewModel.warmupDuration)")
                        }
                    }
                    ForEach(viewModel.intervals.cycles, id: \.id) {
                        cycle in
                        Section {
                            NavigationLink(destination:
                            //selects the number of sets for the warm up phase
                                IntervalView()) {
                                HStack {
                                    Text("Interval Cycle")
                                    Spacer()
                                    Text("\(cycle.numberOfSets) set")
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
    
}


struct WorkoutCreationViewForm_Previews: PreviewProvider {
    static var previews: some View{
        WorkoutCreationEditViewForm(
            viewModel: WorkoutCreationEditViewModel(workout: WorkoutBlueprint.initial))
    }
}



