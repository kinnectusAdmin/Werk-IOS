//
//  WerkApp.swift
//  Werk
//
//  Created by Shaquil Campbell on 10/2/22.
//

import SwiftUI

@main
struct WerkApp: App {
    var body: some Scene {
        WindowGroup {
            WorkoutCreationViewForm(viewModel: WorkoutCreationViewModel())
        }
    }
}
