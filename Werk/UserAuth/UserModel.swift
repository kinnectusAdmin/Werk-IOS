//
//  UserModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/22/23.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    
    var intials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension UserModel {
    static var MOCK_USER = UserModel(id: NSUUID().uuidString, fullName: "Shaquil Campbell", email: "gettingthere@gmail.com")
}
