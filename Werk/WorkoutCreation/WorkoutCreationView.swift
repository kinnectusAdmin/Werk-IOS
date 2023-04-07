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
   
    
    
    
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    HStack {
                        
                        TextField("Timer Name",text: viewModel.workoutNameBinding)
                            .keyboardType(.alphabet)
                        ColorPicker("", selection: $viewModel.bgColor)
                    }
                }
                NavigationLink(destination: WarmUpView(viewModel: WarmUpViewModel(warmup: viewModel.workout.warmup, updateFunction: { warmup in
                    viewModel.didUpdateWarmup(warmup: warmup)
                }))) {
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
                        
                        NavigationLink(destination: Text("High Intensity View")) {
                            HStack {
                                Text("High Intensity")
                                Spacer()
                                Text("\(cycle.highIntensity.duration)")
                            }
                        }
                        NavigationLink(destination: Text("Low Intensity View")) {
                            HStack {
                                Text("Low Intensity ")
                                Spacer()
                                Text("\(cycle.lowIntensity.duration)")
                            }
                            //data transfer between views
                            //pass the parent view model to presented child viewmodel so the child has a subset of the data that it needs. once the child mutates the date it needs to report to the parent
                            //read up on structs
                            //refresh on MVVM MVM Viper and MVI and  MVC
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
                    
                    NavigationLink(destination: Text("Cool Down View")) {
                        HStack {
                            Text("Cool Down ")
                            Spacer()
                            Text(viewModel.cooldownDuration)
                        }
                        
                    }
                    
                }
            }.toolbar {   //this placement type bolds the item and places it on the top right of the screen
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        
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





