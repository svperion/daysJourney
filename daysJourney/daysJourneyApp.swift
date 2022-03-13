//
//  daysJourneyApp.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

@main
struct daysJourneyApp: App {
    @StateObject var jViewModel = LogInViewModel()
    var body: some Scene {
        WindowGroup {
            if jViewModel.isLoggedIn {
                ContentView()
                        .environmentObject(jViewModel)
            } else {
                LoginView()
                        .environmentObject(jViewModel)
            }

        }
    }
}






