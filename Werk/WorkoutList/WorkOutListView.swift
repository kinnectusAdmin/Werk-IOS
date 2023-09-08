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
    @State var selectedWorkout:WorkoutBlueprint? = nil
    
    var body: some View {
        ZStack {
            //List
            NavigationView{
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        Text("My Workouts").font(.title)
                        Spacer()
                    }
                    Spacer().frame(height: 8)
                    List{
                        ForEach(viewModel.workOuts, id: \.id) { workOut in
                            Button(action: {
                                selectedWorkout = workOut
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(workOut.name)
                                    Text(durationOfWorkout(duration: Double(workOut.duration)))
                                }
                            }
                            .padding(.bottom)
                            
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button("Delete") {
                                    viewModel.deleteWorkout(at: workOut)
                                    
                                }
                            }
                        }
                    }
                    HStack {
                        //button to add workout
                        Spacer()
                        Button() {
                            showingSheet.toggle()
                        } label: {
                            ZStack{
                                Circle().frame(width: 60, height: 60)
                                Image(systemName: "plus").foregroundStyle(Color.white)
                            }.padding(.bottom, 100)
                        }.sheet(isPresented: $showingSheet) {
                            WorkoutCreationEditViewForm(viewModel: WorkoutCreationEditViewModel())
                        }
                        Spacer()
                    }.padding(.bottom, 30)
                        .frame(maxHeight:0)
                }
            }
        }.frame(maxHeight: .infinity)
            .fullScreenCover(item: $selectedWorkout) { workout in
                TimerView(viewModel: TimerViewModel(workout: workout))
            }
        
    }
}

struct WorkOutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutListView(viewModel: WorkoutListViewModel())
    }
    
}

