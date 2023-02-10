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
    var intViewModel: IntervalViewModel = IntervalViewModel()
    
    
    
    var body: some View {
        NavigationStack{
            Form {
                
                Section {
                    
                    HStack(alignment: .bottom) {
                        Picker("Number of sets", selection: intViewModel.$numberOfsets) {
                            ForEach(1 ..< 100) {
                                Text("\($0)")
                            }
                            
                        }.frame(maxHeight: .infinity, alignment: .bottom)
                        
                    }
                }
                
                Section {
                    List {
                        ForEach(intViewModel.phases) { phase in
                            HStack {
                                Text("\(phase.name)")
                                Spacer()
                                Text("\(phase.duration)")
                            }
                        }.onMove(perform: intViewModel.move)
                    }
                }
            }.environment(\.editMode, intViewModel.$editMode)
        }
    }
}

struct IntervalDetails_Previews: PreviewProvider {
    static var previews: some View {
        IntervalDetails(intViewModel: IntervalViewModel())
    }
}

