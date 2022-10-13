//
//  WorkoutHistoryView.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/6/22.
//

import SwiftUI
import DataDetection


struct WorkoutHistoryView: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Workout History").font(.title)
            }
            TabView{
                ForEach((1..<53)) { weekOfYear in
                    
                    VStack {
                        Text("week \(weekOfYear)")
                        Text(weekRangeOfYear(week:weekOfYear).2)
                        Spacer()
                        HStack(spacing: 45)
                        {
                            Text("S")
                            Text("M")
                            Text("T")
                            Text("W")
                            Text("T")
                            Text("F")
                            Text("S")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .tabViewStyle(.page)
            
            
        }
        
    }
    
    struct WorkoutHistoryView_Previews: PreviewProvider {
        static var previews: some View {
            WorkoutHistoryView()
        }
    }
}
