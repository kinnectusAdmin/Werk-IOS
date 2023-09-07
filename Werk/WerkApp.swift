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
            ZStack {
                VStack {
                    WorkoutHistoryView()
                    Spacer()
                } 
                VStack {
                    Spacer()
                    WorkOutListView(viewModel: .init())
                }
            }
        }
    }
}
