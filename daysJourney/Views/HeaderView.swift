//
// Created by Orion Neguse on 2022-03-12.
//

import SwiftUI

struct DatedHeader: View {
    let headerStr: String
    let headerColor: Color
    let alignment: Alignment
    let dateStr: String

    @State var presentingModal = false

    var body: some View {
        VStack {
            TopHeader(headerStr: headerStr, headerColor: headerColor, alignment: alignment)

            Button(dateStr + " >") {
                self.presentingModal = true
            }
                    .sheet(isPresented: $presentingModal) {
                        CalendarModal()
                    }
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
        }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
    }
}

struct TopHeader: View {
    let headerStr: String
    let headerColor: Color
    let alignment: Alignment

    var body: some View {
        Text(headerStr)
                .font(.largeTitle)
                .foregroundColor(headerColor)
                .padding(.bottom, 10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: alignment)
    }
}