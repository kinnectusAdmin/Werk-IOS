//
//  WorkOutListView.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/2/22.
//

import SwiftUI


struct WorkOutListView: View {
    @ObservedObject var viewModel: WorkoutListViewModel
    @State var showingSheet = false
    
    var body: some View {
        ZStack {
            //List
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("My Workouts").font(.title)
                    Spacer()
                }
                Spacer().frame(height: 8)
                ScrollView {
                    ForEach(viewModel.workOuts, id: \.id) { workOut in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(workOut.name)
                            Text(durationOfWorkout(duration: Double(workOut.duration)))
                            Divider()
                        }.onTapGesture {
                            viewModel.didSelectWorkout(workout:workOut)
                        }
                    }
                }
            }
            .frame(maxHeight: 200)
            .padding(.leading, 12)
        
            VStack {
                //button to add workout
                Spacer()
                Button {
                    showingSheet.toggle()
                } label: {
                    ZStack{
                        Circle().frame(width: 60, height: 60)
                        Image(systemName: "plus").foregroundStyle(Color.white)
                    }
                }.sheet(isPresented: $showingSheet) {
                    WorkoutCreationEditViewForm(viewModel: WorkoutCreationEditViewModel())
                }
            }
        }
        
    }
}

struct WorkOutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutListView(viewModel: WorkoutListViewModel())
    }
    
}

