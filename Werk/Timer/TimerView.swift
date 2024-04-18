//
//  TimerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/25/23.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel:TimerViewModel = TimerViewModel(workout: WorkoutBlueprint.initial())
    @State private var showingSheet = false
    @State private var key = UUID()
    
    
    var body: some View {
        
        ZStack{
            VStack {
                HStack {
                    //exit button, workout name, and edit button
                    // exit button
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .padding(.all, 25)
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
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .padding(.all, 25)
                            .background(Color.black.opacity(0.0))
                            .clipShape(Circle())
                        
                    }.sheet(isPresented: $showingSheet) {
                        let editViewModel = WorkoutCreationEditViewModel(workout: viewModel.workout) { updatedWorkout in
                            self.viewModel.updateWorkout(with: updatedWorkout)
                        }
                        WorkoutCreationEditViewForm(viewModel: editViewModel)
                    }
                    
                }
                //time remaining in workout
                Text("\(viewModel.convertedCurrentPhaseTime)")
                    .font(.system(size: 100.00, weight: .bold))
                    .foregroundColor(.white)
                HStack{
                    // phase info and control settings
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
                        Text(viewModel.displayedPhasename)
                            .multilineTextAlignment(.center)
                        Text(viewModel.displayedSetInfo)
                    }.foregroundColor(.white)
                    Spacer()
                    //goes to the next phase in workout
                    Button {
                        viewModel.didPressNextPhase()
                        viewModel.didPressStartorResume()
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
                    //time elapsed and remaining info
                    Spacer()
                    //shows the total amont of time that has elapsed during the workout
                    Text(viewModel.displayedElapsedTime)
                        .multilineTextAlignment(.center)
                    Spacer()
                    //shows the total duration of the workout
                    Text(viewModel.displayedTimeRemaining)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .foregroundColor(.white)
                Spacer()
                HStack{
                    //lock button, start button/timer animation, reset button
                    Button {
                        // blocks user screen interaction
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
                    ZStack {
                        // timer display circle
                        Circle()
                            .stroke(Color.gray, lineWidth: 5)
                            .frame(width: 220, height: 220)
                        // shows decrease in time over course of current phase
                        Circle()
                            .trim(from: 0.0, to: viewModel.circleProgress)
                            .stroke(Color.white, lineWidth: 2.5)
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                        Button {
                            //  start/resume button
                            viewModel.didPressStartorResume()
                        } label: {
                            ZStack {
                                Circle()
                                    .opacity(0.0)
                                    .frame(width: 100, height: 100)
                                Text(viewModel.isTimerActive ? "Pause" : viewModel.elapsedTime > 0 ? "Resume" : "Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    Button {
                        //resets timer
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
            }

            
        }.navigationBarBackButtonHidden(true)
            .background(viewModel.changeBackgroundColor(phaseName: viewModel.currentPhaseName))
            .alert(isPresented: viewModel.isTimerFinished){
                Alert(title: Text("Great Job !"), message: Text("Would You Like To Save This Workout?"),
                      dismissButton: .cancel(Text("Save"), action: viewModel.didSelectSavedWorkout)
                )
//            }.onTapGesture {
//                self.presentationMode.wrappedValue.dismiss()
//                print("Gesture tapped")
            }
    }
    
}


struct LowerTimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: TimerViewModel(workout: WorkoutBlueprint.initial()))
    }
}
