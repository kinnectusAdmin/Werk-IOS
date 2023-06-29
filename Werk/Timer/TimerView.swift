//
//  TimerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/25/23.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel:TimerViewModel = TimerViewModel(workout: WorkoutBlueprint.initial)
    
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
                    }.disabled(!viewModel.isScreenLocked)
                    
                    
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
                Text("\(viewModel.currentPhaseTime)")
                //should be duration of current block minus time elapsed
                    .font(.largeTitle)
                //                    .onReceive(viewModel.$timer) { _ in
                //                        if Int(viewModel.work)! > 0 {
                //                            Int(viewModel.timeRemaining)  -= 1
                //                        }
                //                    }
                
                HStack{
                    // Goes back to the previous phase in workout
                    Button {
                        viewModel.didPressPreviousPhase()
                    } label: {
                        Image(systemName: "lessthan")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                    //displays current set
                    VStack{
                        Text("\(viewModel.currentPhaseName)")
                            .multilineTextAlignment(.center)
                        Text("\(viewModel.currentPhaseIndex+1)/\(viewModel.workoutBlocks.count) Set")
                    
                    }
                    
                    
                    Spacer()
                    
                    //goes to the next phase in workout
                    Button {
                        viewModel.didPressNextPhase()
                    } label: {
                        Image(systemName: "greaterthan")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                
                HStack{
                    Spacer()
                    //shows the total amont of time that has elapsed during the workout
                    Text("\(viewModel.elapsedTime) \nElapsed")
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    //shows the total duration of the workout
                    Text("\(viewModel.timeRemaining) \nRemaining")
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                Spacer()
                
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
                    }
                    //.enable bind to bool
                    
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
                        
                        //  start/resume button
                        Button {
                            viewModel.didPressStartorResume()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.cyan)//Will remove after button code is set
                                    .opacity(0.2)
                                    .frame(width: 100, height: 100)
                                Text(viewModel.isTimerActive ? "Pause" : viewModel.elapsedTime > 0 ? "Resume" : "Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }.disabled(viewModel.isScreenLocked)
                        
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
                    }.disabled(viewModel.isScreenLocked)
                }
                
                Spacer()
                
                
                HStack{
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                            .resizable()
                            .frame(width: 30, height: 20)
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .foregroundColor(.white)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                            .resizable()
                            .frame(width: 30, height: 20)
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "music.note.list")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    .foregroundColor(.white)
                    
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
