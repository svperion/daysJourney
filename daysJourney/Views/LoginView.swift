//
// Created by Orion Neguse on 2022-03-12.
//

import SwiftUI

// TODO: FINISH LOGIN FUNCTIONALITY
struct LoginView: View {
    @State var username = ""
    @EnvironmentObject private var liViewModel: LogInViewModel

    var body: some View {
        VStack {
            TextField(text: $username, label: {
                Text("Enter a username:")
            })
                    .padding(.bottom)

            Button(action: {
                liViewModel.logIn(username: username)
            }, label: {
                Text("Login")
            })
                    .buttonStyle(.bordered)

        }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal)
    }
}
