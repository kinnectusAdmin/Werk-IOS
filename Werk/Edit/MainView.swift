//
//  EditCombined.swift
//  Werk
//
//  Created by Shaquil Campbell on 4/22/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView{
            VStack {
                WorkoutHistoryView()
                    .padding(.bottom, 16) // Add some spacing between the views
                WorkOutListView(viewModel: WorkoutListViewModel())
            }.toolbar{
                ToolbarItem {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image(systemName: "person.circle")
                    }
                }
            }
        }
    }
}

struct EditCombined_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
