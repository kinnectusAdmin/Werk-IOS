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
    @ObservedObject var viewModel: IntervalViewModel = IntervalViewModel()
 
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    HStack(alignment: .bottom) {
                        Picker("Number of sets", selection: viewModel.numberOfsetsBinding) {
                            ForEach(1 ..< 100) {
                                Text("\($0)")
                            }
                        }.frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                Section {
                    List {
                        ForEach(viewModel.phases) { phase in
                            HStack {
                                Text("\(phase.name)")
                                Spacer()
                                Text("\(phase.duration)")
                            }
                        }.onMove(perform: viewModel.move)
                    }
                }.environment(\.editMode, $viewModel.editMode)
            }
        }
    }
}

struct IntervalView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalView(viewModel: IntervalViewModel())
    }
}

