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
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    

    var body: some Scene {
        WindowGroup {
            GroupedViews()
                .environmentObject(authenticationViewModel)
//                WorkoutHistoryView()
//                    .padding(.bottom, 16) // Add some spacing between the views
//                WorkOutListView(viewModel: WorkoutListViewModel())
            
        }
    }
}
