//
//  DetailAdjustmentView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI

struct DetailAdjustmentView: View {

    @State var title: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Snooze")
                    .foregroundColor(.background)
                    .bold()
                    .frame(width: 100, height: 50)
                    .background {
                        AsymmetricalRoundedRectangle(10, 24, 24, 24)
                            .fill(Color.snooze)
                    }
                Spacer()
                Text("Delete")
                    .foregroundColor(.background)
                    .bold()
                    .frame(width: 100, height: 50)
                    .background {
                        AsymmetricalRoundedRectangle(24, 10, 24, 24)
                            .fill(Color.delete)
                    }
            }
            TextField("Title", text: $title)
                .foregroundColor(.background)
                .font(.largeTitle)
        }
        .padding(20)
    }
}
