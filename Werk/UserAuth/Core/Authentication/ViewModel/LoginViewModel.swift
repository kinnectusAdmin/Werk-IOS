//
//  LoginViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/22/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class LoginViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //Firebase user object
    @Published var currentUser: UserModel? //Model for user data

    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign In")
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            //allows await for the result instead of using completion blocks
            // ayncrounus code in a syncronus way
            self.userSession = result.user
            let user = UserModel(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do {try Auth.auth().signOut()
            self.userSession = nil // clears user session
            self.currentUser = nil // clears curent user so there is no data persistance upon new user log in
            
        } catch {
            print("FAILED TO LOG OUT \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        print("Delete Account")
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapShot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapShot.data(as: UserModel.self)
    }
}

