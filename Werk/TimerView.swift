//
//  TimerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/25/23.
//

import SwiftUI

struct TimerView: View {
    @State private var timeElapsed = 0
    @State private var timerActive = false
    @State private var timer: Timer? = nil
    let interval: Int = 0
    
    var body: some View {
        ZStack{
            Color.purple.ignoresSafeArea()
            HStack{
                Circle()
                    .frame(width: 70, height: 70,alignment: .leading)
                    .padding(10)
                ZStack {
                    
              
                        
                    Circle()
                    
                        .stroke(Color.gray, lineWidth: 5)
                        .frame(width: 220, height: 220)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeElapsed) / CGFloat(interval))
                        .stroke(Color.white, lineWidth: 2.5)
                        .frame(width: 220, height: 220)
                        .rotationEffect(.degrees(90))
                    
              
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .opacity(0.2)
                                .frame(width: 100, height: 100)
                            
                            Text(timerActive ? "Pause" : "Start")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                }
                Circle()
                    .frame(width: 70, height: 70,alignment: .leading)
                    .padding(10)
            }
        }
        
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
