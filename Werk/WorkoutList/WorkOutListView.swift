//
//  WorkOutListView.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/2/22.
//

import SwiftUI


struct WorkOutListView: View {
    
    @StateObject var viewModel: WorkoutListViewModel
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("My Workouts").font(.title)
                Spacer()
            }
            Spacer().frame(height: 8)
            ZStack {
                ScrollView {
                    ForEach(viewModel.workOuts, id: \.id) { workOut in
                        VStack(alignment:.leading, spacing: 8) {
                            Text(workOut.name)
                            Text(workOut.durationOfWorkout())
                            Divider()
                        }.onTapGesture {
                            viewModel.didSelectWorkout(workout:workOut)
                        }
                       
                    }
                }
                VStack{
                    Spacer()
                    Button {
                        viewModel.didSelectAddWorkout()
                    } label: {
                        ZStack{
                            Circle().frame(width: 60, height: 60)
                            Image(systemName: "plus").foregroundStyle(Color.white).frame(width: 90, height: 90)
                        }
                    }
                }

            }
        }.padding(.leading, 12)
    }
}
struct WorkOutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutListView(viewModel: WorkoutListViewModel(workOuts: (0...9).map{_ in
            WorkOutExercise.randomWorkout}))
    }

}

//research VIPER MVVM
// create a viewModel to hold the data

