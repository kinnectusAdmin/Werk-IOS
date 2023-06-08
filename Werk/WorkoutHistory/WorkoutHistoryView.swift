//
//  WorkoutHistoryEdit.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/6/22.
//

import SwiftUI
import DataDetection


struct WorkoutHistoryView: View {
    @ObservedObject var viewModel = WorkoutHistoryViewModel()
    
    var body: some View {
        
        VStack(spacing: 0){
            Text("Workout History").font(.title)
            
            TabView(selection: $viewModel.weekSelection){
                ForEach((0..<53)) { weekOfYear in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Week \(weekOfYear)").font(.title2).bold()
                                Text(weekRangeOfYear(week:weekOfYear).2)
                            }
                            Spacer()
                            Text("Details >").onTapGesture {
                                //WORKOUTHISTORYDETAILSVIEW
                            }
                        }
                        .padding(10)
                        
                        HStack(alignment: .bottom, spacing: 20) {
                            ForEach(viewModel.bars) { bar in
                                VStack {
                                    Rectangle()
                                        .foregroundStyle(LinearGradient(colors: bar.color, startPoint: .bottom, endPoint: .top))
                                        .frame(width: 35, height: viewModel.relativeDuration(duration: bar.totalDuration),
                                               alignment: .bottom)
                                        .cornerRadius(90)
                                    Text(bar.day)
                                }
                            }
                        }
                        .padding(20)
                    }.tag(weekOfYear)
                }
            }
            .frame(maxHeight: 270)
            .tabViewStyle(.page)
        }
        
    }
    
    struct WorkoutHistoryEdit_Previews: PreviewProvider {
        static var previews: some View {
            VStack(spacing: 0) {
                WorkoutHistoryView()
                Spacer()
            }
        }
    }
}

