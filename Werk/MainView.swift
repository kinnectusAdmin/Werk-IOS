//
//  EditCombined.swift
//  Werk
//
//  Created by Shaquil Campbell on 4/22/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            VStack {
                WorkoutHistoryEdit()
                Spacer()
            }
            VStack {
                Spacer()
                WorkOutListView(viewModel: WorkoutListViewModel())
            }
        }
    }
}

struct EditCombined_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
