//
//  daysJourneyApp.swift
//  daysJourney
//
//  Created by Orion Neguse on 2022-01-30.
//

import SwiftUI

@main
struct daysJourneyApp: App {
    @StateObject var liViewModel = LogInViewModel()
    var body: some Scene {
        WindowGroup {
            if liViewModel.isLoggedIn {
                ContentView()
                        .environmentObject(liViewModel)
            } else {
                LoginView()
                        .environmentObject(liViewModel)
            }

        }
    }
}






