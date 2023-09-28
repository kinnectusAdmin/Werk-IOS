//
//  AppDelegate.swift
//  Werk
//
//  Created by Shaquil Campbell on 4/20/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//      Auth.auth()
      
      
      //this is the instance that can connect directly to my authenticatin manager
      //how ppl can sign in and sign out
    return true
  }
    
}

