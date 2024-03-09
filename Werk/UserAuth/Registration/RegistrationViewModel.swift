//
//  RegistrationViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/26/23.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var fullName = ""
    @Published var password = ""               // put State vars in a RegistrationViewModel class make it obserable
    @Published var confrimPassword = ""
}

extension RegistrationViewModel: AuthenticationFormPotocol {
    var formIsValid: Bool { //requirements for user to log in
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confrimPassword == password
        && !fullName.isEmpty
    }
}
