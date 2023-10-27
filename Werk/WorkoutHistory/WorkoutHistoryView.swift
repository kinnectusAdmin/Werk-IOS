//
//  WorkoutHistoryEdit.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/6/22.
//

import SwiftUI
import DataDetection
import Charts

struct WorkoutHistoryView: View {
    @ObservedObject var viewModel = WorkoutHistoryViewModel()
    
    var body: some View {
        VStack(spacing: 0){
            //Graph and weekly workout stats
            Text("Workout History").font(.title)
            TabView(selection: $viewModel.weekSelection){
                ForEach((0..<53)) { weekOfYear in
                    VStack {
                        HStack {
                            HStack {
                                Text("Week \(weekOfYear)").font(.title2).bold()
                                Spacer()
                                Text(weekRangeOfYear(week:weekOfYear).2)
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

