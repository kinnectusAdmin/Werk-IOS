//
//  BarChartView.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/24/24.
//

import SwiftUI
import Charts

struct WorkoutBarChartView: View {
    @ObservedObject var viewModel = WorkoutBarChartViewModel()

    var body: some View {
        VStack {
            BarChartView(
                data: viewModel.workoutData,
                title: "Workout Duration",
                legend: "Days of the Week",
                labels: viewModel.daysOfWeek
            )
            .frame(height: 300)
            .padding()
        }
    }
}

struct WorkoutBarChatView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(data: [12.1,12.3], title: "", legend: "", labels: ["",""])
        
    }
    }
