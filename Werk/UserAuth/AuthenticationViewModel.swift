//
//  LoginViewModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/22/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormPotocol {
    var formIsValid: Bool {get}
}

@MainActor
class AuthenticationViewModel: ObservableObject {

    @Published var userSession: FirebaseAuth.User? //Firebase user object
    @Published var currentUser: UserModel? //Model for user data

    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    private func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("FAILED TO LOG IN \(error.localizedDescription)")
        }
    }
    
    func didSelectSignIn(withEmail email: String, password: String) {
        Task { //must be wrapped in TASK becuase this is using "async await"
            try await signIn(withEmail: email, password: password)
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do{ //split this
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
    
    func didCreateUser(withEmail email: String, password: String, fullName: String) {
        Task{
            try await createUser(withEmail: email, password: password, fullName: fullName)
        }
    }
    
    func signOut(){
        do {try Auth.auth().signOut() //signs user out on back end
            self.userSession = nil // clears user session
            self.currentUser = nil // clears curent user so there is no data persistance upon new user log in
            UserDefaults.standard.recordedWorkouts = []
            UserDefaults.standard.workoutBlueprints = []
            UserDefaults.standard.removeObject(forKey: DataKey.userId.rawValue)
            
        } catch {
            print("FAILED TO LOG OUT \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        print("Delete Account")
    }
    
    func getWorkoutBlueprint() {
        DataStorageService().getWorkoutBlueprintsRemote()
    }
    
    func getRecordedWorkouts() {
        DataStorageService().getRecordedWorkoutsRemote()
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        do {
            let snapShot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try? snapShot.data(as: UserModel.self)
            let user = try JSONEncoder().encode(self.currentUser!)
            UserDefaults.standard.userData = user
            getWorkoutBlueprint()
            getRecordedWorkouts()
        } catch {
            print(error.localizedDescription)
        }
    }
}

