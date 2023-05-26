//
//  TimerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/25/23.
//

import SwiftUI

struct LowerTimerView: View {
    private let model = TimerModel()
   
    let interval: Int = 0
    
    var body: some View {
        ZStack{
            
            Color.purple.ignoresSafeArea()
            VStack {
                HStack{
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 50, height: 50,alignment: .leading)
                        .padding(10)
                        Image(systemName: "lock")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                            .padding()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                    }
                    ZStack {
                        
                  
                            
                        Circle()
                        
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: 220, height: 220)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(model.timeElapsed) / CGFloat(interval))
                            .stroke(Color.white, lineWidth: 2.5)
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(90))
                        
                  
                            ZStack {
                                Circle()
                                    .fill(Color.black)//Will remove after button code is set
                                    .opacity(0.2)
                                    .frame(width: 100, height: 100)
                                
                                Text(model.isActive ? "Pause" : "Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                    }
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 50, height: 50,alignment: .leading)
                        .padding(10)
                        Image(systemName: "arrow.counterclockwise")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                            .padding()
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct LowerTimerView_Previews: PreviewProvider {
    static var previews: some View {
        LowerTimerView()
    }
}
