//
//  WerkApp.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/2/22.
//

import SwiftUI
import Firebase

@main
struct WerkApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var logInVM = LoginViewModel()
    

    var body: some Scene {
        WindowGroup {
            GroupedViews()
                .environmentObject(logInVM)
                .environment(\.colorScheme, .dark)
//                WorkoutHistoryView()
//                    .padding(.bottom, 16) // Add some spacing between the views
//                WorkOutListView(viewModel: WorkoutListViewModel())
            
        }
    }
}
