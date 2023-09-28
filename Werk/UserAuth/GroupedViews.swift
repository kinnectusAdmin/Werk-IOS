//
//  GroupedViews.swift
//  Werk
//
//  Created by Shaquil Campbell on 9/22/23.
//

import SwiftUI

struct GroupedViews: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        Group {
            if authenticationViewModel.userSession != nil {
                MainView()
            } else {
                LogInView().environmentObject(authenticationViewModel)
            }
        }
    }
}

struct GroupedViews_Previews: PreviewProvider {
    static var previews: some View {
        GroupedViews().environmentObject(AuthenticationViewModel())
    }
}
