//
//  GroupedViews.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/22/23.
//

import SwiftUI

struct GroupedViews: View {
    @EnvironmentObject var logInVM: LoginViewModel
    
    var body: some View {
        Group {
            if logInVM.userSession != nil {
                ProfileView()
            } else {
                LoginView()
            }
        }
    }
}

struct GroupedViews_Previews: PreviewProvider {
    static var previews: some View {
        GroupedViews().environmentObject(LoginViewModel())
    }
}
