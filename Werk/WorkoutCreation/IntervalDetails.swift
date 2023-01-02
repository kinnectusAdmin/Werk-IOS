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

struct IntervalDetails: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: WorkoutCreationViewModel
    @State var numberOfsets = 1
    var intenseArray = [
    
    
    ]
    
    
    var body: some View {
        NavigationView{
            List {
                
                Section {
                    
                    HStack(alignment: .bottom) {
                        Picker("Number of sets", selection: $numberOfsets) {
                            ForEach(0 ..< 100) {
                                Text("\($0)")
                            }
                            
                        }.frame(maxHeight: .infinity, alignment: .bottom)
                        
                    }
                }
                
                Section {
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
                }
            }        .navigationTitle("Interval Cycle")
            
        }
    }
    





struct IntervalDetails_Previews: PreviewProvider {
    static var previews: some View {
        IntervalDetails(viewModel: WorkoutCreationViewModel())
    }
}

//extension IntervalDetails {
//
//    var numberOfSets: some View {
//
//
//
//}
