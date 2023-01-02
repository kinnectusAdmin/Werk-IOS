//
//  WorkoutCreationView.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/8/22.
//

import Foundation
import SwiftUI


struct WorkoutCreationViewForm: View {
    var viewModel: WorkoutCreationViewModel
    

    
    @State var bgColor =
    Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    HStack {

                        TextField("Timer Name",text: viewModel.workoutNameBinding)
                            .keyboardType(.alphabet)
                        Spacer()
                        ColorPicker("", selection: $bgColor)
                    }
                }
                NavigationLink(destination: WarmUpDetails()) {
                    HStack {
                        Text("Warm Up")
                        Spacer()
                        Text("\(viewModel.warmupDuration)")
                    }
                }
                
                Section {
                    
                    NavigationLink(destination: Text("Interval View")) {
                        HStack {
                            Text("Interval Cycle")
                            Spacer()
                            Text("\(viewModel.setNumber.count) set")
                            
                        }
                    }
                    
                    NavigationLink(destination: Text("High Intensity View")) {
                        HStack {
                            Text("High Intensity")
                            Spacer()
                            Text("\(viewModel.highIntensityDuration)")
                        }
                    }
                    NavigationLink(destination: Text("Low Intensity View")) {
                        HStack {
                            Text("Low Intensity ")
                            Spacer()
                            Text("\(viewModel.lowIntensityDuration)")
                        }
                        
                    }
                    
                }
                
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
                        
                    }
                }
            }
        }
        
    }
    
}


struct WorkoutCreationViewForm_Previews: PreviewProvider {
    static var previews: some View{
        WorkoutCreationViewForm(viewModel: WorkoutCreationViewModel())
    }
}


// A Vstack of view
//one view is a view of warm up phase
//second is the interval phase
//3rd 
// watch a video on view Hiearchy





