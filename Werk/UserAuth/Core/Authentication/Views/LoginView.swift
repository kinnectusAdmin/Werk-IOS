//
//  LoginView.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/21/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var logInVM: LoginViewModel
    var body: some View {
        NavigationStack {
            VStack{
                //image
                Image(systemName:"waveform.path.ecg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                // form fields
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password",
                              isSecureField: false)
                        .autocapitalization(.none)
                }
               
                .padding(.horizontal)
                .padding(.top, 12)
                
                //sign in
                Button {
                    Task{
                        //must be wrapped in TASK becuase this is using "async await"
                        try await logInVM.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack{
                        Text("SIGN IN")
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
                //sign up navigates to RegistrationView
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't Have An Account?")
                            .foregroundColor(.teal)
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size:14))
                }
            }
            .background(Color("ViewModel"))
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(LoginViewModel())
        
        
    }
}
