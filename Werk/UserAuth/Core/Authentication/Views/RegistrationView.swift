//
//  RegistrationView.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/22/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confrimPassword = ""
    @Environment(\.dismiss) var dimiss
    @EnvironmentObject var logInVM: LoginViewModel
    // enviormentObjects only get initalized ONCE
    // use envoirmentObjects to avoid creating multiple instances of the viewModel
    
    
    var body: some View {
        VStack{
            Image(systemName:"waveform.path.ecg")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            // form fields
            VStack(spacing: 24) {
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $fullName, title: "Full Name", placeholder: "Enter Your Name")
                
                InputView(text: $password, title: "Password", placeholder: "Enter your password",
                          isSecureField: true)
                
                InputView(text: $confrimPassword, title: "Confirm Password", placeholder: "Re-Enter Password",
                          isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task{
                    try await logInVM.createUser(
                        withEmail:email,
                        password: password,
                        fullName: fullName
                    )
                }
            } label: {
                HStack{
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color.teal)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dimiss()
            } label: {
                HStack(spacing: 3){
                    Text("Don't Have An Account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size:14))
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(LoginViewModel())
    }
}
