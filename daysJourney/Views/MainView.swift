//
// Created by Orion Neguse on 2022-04-03.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            Text("allJourney")
                    .navigationBarTitleDisplayMode(.automatic)
                    .toolbar {
                        ToolbarItem(placement: .principal) {

                        }
                    }
            VStack {
                Text("Main View")
            }
        }

    }
}
