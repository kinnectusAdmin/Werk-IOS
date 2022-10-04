//
//  WorkOutListView.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/2/22.
//

import SwiftUI


struct WorkOutListView: View {
    
    var workOuts: [WorkOutExercise]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("My Workouts").font(.title)
                Spacer()
            }
            Spacer().frame(height: 8)
            ScrollView {
                ForEach(workOuts, id: \.id) { workOut in
                    VStack(alignment:.leading, spacing: 8) {
                        Text(workOut.name)
                        Text(workOut.durationOfWorkout())
                        Divider()
                    }
                   
                }
            }
        }.padding(.leading, 12)
    }
}
struct WorkOutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutListView(workOuts: (0...9).map{_ in
            WorkOutExercise.randomWorkout})
    }
}

//research VIPER MVVM
// create a viewModel to hold the data
