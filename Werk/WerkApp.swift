//
//  WerkApp.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/2/22.
//

import SwiftUI

@main
struct WerkApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            
                WorkoutHistoryView()
                    .padding(.bottom, 16) // Add some spacing between the views
                WorkOutListView(viewModel: WorkoutListViewModel())
            
        }
    }
}
