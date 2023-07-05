////
////  TimerModel.swift
////  Werk
////
////  Created by Shaquil Campbell on 12/13/22.
////
//import SwiftUI
//import Foundation
//
//
//struct TimerModel {
//    @State var timeRemaining: TimeInterval = 0
//    @State var timeElapsed = 0
//    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    @State var isActive = false
//    var showingAlert = false
//    var time: String = "00:00"
//    var minutes: Double = 5.0 {
//        didSet {time = "\(minutes)"
//        }
//    }
//    var initialTime = 0.0
//    private var endDate = Date()
//    
//    // Start the timer with the given amount of minutes
//    mutating func start(minutes: Double) {
//        initialTime = minutes
//        endDate = Date()
//        isActive = true
//        endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
//    }
//    
//    // Reset the timer
//    mutating func reset() {
//        minutes = Double(initialTime)
//        isActive = false
//        time = "\(minutes)"
//    }
//    
//    
//    // Show updates of the timer
//    mutating func updateCountdown(){
//        guard isActive else { return }
//        
//        // Gets the current date and makes the time difference calculation
//        let now = Date()
//        let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
//        
//        // Checks that the countdown is not <= 0
//        if diff <= 0 {
//            isActive = false
//            time = "0:00"
//            showingAlert = true
//            return
//        }
//        
//        // Turns the time difference calculation into sensible data and formats it
//        let date = Date(timeIntervalSince1970: diff)
//        let calendar = Calendar.current
//        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
//        
//        // Updates the time string with the formatted time
//        //        minutes = Double(minutes)
//        time = String(format:"\(minutes):\(seconds)", minutes, seconds)
//    }
//    
//    func timeString(from timeInterval: TimeInterval) -> String {
//       let minutes = Int(timeInterval) / 60
//       let seconds = Int(timeInterval) % 60
//       return String(format: "%02d:%02d", minutes, seconds)
//   }
//}
