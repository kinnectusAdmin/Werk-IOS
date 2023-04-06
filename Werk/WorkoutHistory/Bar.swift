//
//  WorkoutHistoryModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 3/7/23.
//
import Foundation
import SwiftUI


struct Bar: Identifiable {
    
    let id = UUID().uuidString
    var name: String
    var day: String
    var value: [Double]
    var color: [Color] {
        value.map { _  -> Color in
            let color = UIColor.random
            return Color(uiColor: color)
        }
    }
    var totalDuration: CGFloat {
        CGFloat(value.reduce(0, +))
    }
    var workouts: [[WorkoutTemplate]]
}
