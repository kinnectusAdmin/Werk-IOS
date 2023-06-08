//
//  TimerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/25/23.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel:TimerViewModel = TimerViewModel(workout: WorkoutBlueprint.initial)
    
    let interval: Int = 0
    
    var body: some View {
        
        ZStack{
            Color.purple.ignoresSafeArea()
            VStack {
                HStack {
                    // exit button
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .padding(.all, 5)
                            .background(Color.black.opacity(0.0))
                            .clipShape(Circle())
                    }

                  
                    Spacer()
                    // workout name
                    Text("Workout Timer")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    
                    Spacer()
                    
                    //edit button
                    Image(systemName: "pencil.circle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .padding(.all, 5)
                        .background(Color.black.opacity(0.0))
                        .clipShape(Circle())
                    
                    
                }
                
                //time remaining in workout
                Text("\(viewModel.timeRemaining)")
                    .font(.largeTitle)
                //                    .onReceive(viewModel.$timer) { _ in
                //                        if Int(viewModel.work)! > 0 {
                //                            Int(viewModel.timeRemaining)  -= 1
                //                        }
                //                    }
                Spacer()
            }
            HStack{
                
                // blocks user screen interaction
                Button {
                    viewModel.didPressLock()
                } label: {
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
                }.allowsHitTesting(viewModel.isScreenLocked)
                
                ZStack {
                    // timer display circle
                    Circle()
                        .stroke(Color.gray, lineWidth: 5)
                        .frame(width: 220, height: 220)
                    // shows decrease in time over course of current phase
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.white, lineWidth: 2.5)
                        .frame(width: 220, height: 220)
                        .rotationEffect(.degrees(90))
                    
                    // pause start button
                    Button {
                        viewModel.didPressStartorResume()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.black)//Will remove after button code is set
                                .opacity(0.2)
                                .frame(width: 100, height: 100)
                            Text(viewModel.isTimerActive ? "Pause" : "Start")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                //resets timer
                Button {
                    viewModel.didPressReset()
                } label: {
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
        TimerView(viewModel: TimerViewModel(workout: WorkoutBlueprint.initial))
    }
}
