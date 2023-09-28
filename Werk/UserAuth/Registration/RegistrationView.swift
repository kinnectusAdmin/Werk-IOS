//
//  RegistrationView.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/22/23.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dimiss
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
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
                InputView(text: $viewModel.email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                InputView(text: $viewModel.fullName, title: "Full Name", placeholder: "Enter Your Name")
                
                InputView(text: $viewModel.password, title: "Password", placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack(alignment: .trailing) {
                    InputView(text: $viewModel.confrimPassword, title: "Confirm Password", placeholder: "Re-Enter Password",
                              isSecureField: true)
                    
                    if !viewModel.password.isEmpty && !viewModel.confrimPassword.isEmpty {
                        if viewModel.password == viewModel.confrimPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                authenticationViewModel.didCreateUser(withEmail: viewModel.email, password: viewModel.password, fullName: viewModel.fullName)
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
           // .disabled(formIsValid) //checks to see if all text parameteres are met to log in
            .opacity(viewModel.formIsValid ? 1.0 : 0.5) //fills or grays button
            .cornerRadius(10)
            .padding(.top, 24)
            
            
            Spacer()
            
            Button {
                dimiss()
            } label: {
                HStack(spacing: 3){
                    Text("Already Have An Acount?")
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
        RegistrationView().environmentObject(AuthenticationViewModel())
    }
}
