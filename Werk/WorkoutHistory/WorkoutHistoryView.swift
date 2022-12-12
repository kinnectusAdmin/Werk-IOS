//
//  WorkoutHistoryView.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/6/22.
//

import SwiftUI
import DataDetection
import HealthKit


struct WorkoutHistoryView: View {
    @ObservedObject var viewModel = WorkoutHistoryViewModel()
    @State private var selectedID: UUID = UUID()
    @State private var weekSelection: Int = showCurrentWeekNumber(startDate: Date())
    var body: some View {
        
        VStack{
            HStack{
                Text("Workout History").font(.title)
            }
            TabView(selection: $weekSelection){
                ForEach((0..<53)) { weekOfYear in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("week \(weekOfYear)").font(.title2).bold()
                                Text(weekRangeOfYear(week:weekOfYear).2)
                            }
                            Spacer()
                            Text("Details >").onTapGesture {
                                //WORKOUTHISTORYDETAILSVIEW
                            }
                        }.padding(10)
                        Spacer()
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
                        .frame(height:240, alignment: .bottom)
                        .padding(20)
                        .cornerRadius(6)
                    }.tag(weekOfYear)
                }
            }
            .tabViewStyle(.page)
        }
        
    }
    
    struct WorkoutHistoryView_Previews: PreviewProvider {
        static var previews: some View {
            WorkoutHistoryView()
        }
    }
}

