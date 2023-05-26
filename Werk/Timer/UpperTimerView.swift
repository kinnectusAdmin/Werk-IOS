//
//  UpperTimerView.swift
//  Werk
//
//  Created by Shaquil Campbell on 5/25/23.
//

import SwiftUI

struct UpperTimerView: View {
    private let model = TimerModel()
    
    var body: some View {
        
        ZStack {
            Color.purple
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "xmark")
                         .font(.system(size: 25))
                         .foregroundColor(.white)
                         .padding(.all, 5)
                         .background(Color.black.opacity(0.0))
                         .clipShape(Circle())
                         .accessibility(label:Text("Close"))
                         .accessibility(hint:Text("Tap to close the screen"))
                         .accessibility(addTraits: .isButton)
                         .accessibility(removeTraits: .isImage)
//                         .frame(width:130, alignment:.topLeading)
                    
                    Spacer()
                    
                    Text("Workout Timer")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
//                        .padding(.trailing, 100)
                   
                    Spacer()
                    
                    Image(systemName: "pencil.circle")
                         .font(.system(size: 25))
                         .foregroundColor(.white)
                         .padding(.all, 5)
                         .background(Color.black.opacity(0.0))
                         .clipShape(Circle())
                         .accessibility(label:Text("Close"))
                         .accessibility(hint:Text("Tap to close the screen"))
                         .accessibility(addTraits: .isButton)
                         .accessibility(removeTraits: .isImage)
                         
                }
                
                
                Text(model.timeString(from: model.timeRemaining))
                    .font(.largeTitle)
                    .onReceive(model.timer) { _ in
                        if model.timeRemaining > 0 {
                            model.timeRemaining -= 1
                        }
                    }
                Spacer()
            }
        }
    }
}

struct UpperTimerView_Previews: PreviewProvider {
    static var previews: some View {
        UpperTimerView()
    }
}
