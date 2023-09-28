//
//  LogInViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/26/23.
//

import Foundation

class LogInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    // put state objects in a login
    
    
}

extension LogInViewModel: AuthenticationFormPotocol {
    var formIsValid: Bool { //requirements for user to log in
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
    }
}
