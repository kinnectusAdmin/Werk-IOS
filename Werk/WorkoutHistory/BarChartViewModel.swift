//
//  BarChartViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 2/24/24.
//

import Foundation

class WorkoutBarChartViewModel: ObservableObject {
    @Published var workoutData: [Double] = []
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    init() {
        // Initialize workout data with some sample data
        self.workoutData = [30, 45, 60, 20, 50, 40, 55]
    }
}
