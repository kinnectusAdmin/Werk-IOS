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
                            NavigationLink(destination: TimerView(viewModel: TimerViewModel(workout: workOut)))
                            {
                                VStack(alignment: .leading, spacing: 8) {
                                    Divider()
                                    Text(workOut.name)
                                    Text(durationOfWorkout(duration: Double(workOut.duration)))
                                    Divider()
                                }.navigationBarBackButtonHidden(true)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button("Delete") {
                                    viewModel.deleteWorkout(at: workOut)
                                }
                            }
                        }
                    }
                }
            }
            
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
            }.padding(.bottom, 30)
        }.frame(maxHeight: .infinity)
    }
}

struct WorkOutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutListView(viewModel: WorkoutListViewModel())
    }
    
}

