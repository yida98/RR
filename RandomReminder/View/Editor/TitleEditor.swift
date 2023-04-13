//
//  TitleEditor.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/13/23.
//

import Foundation
import SwiftUI

struct TitleEditor: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("TITLE")
                    .subtitle()
                Spacer()
            }
            TextField("Title", text: $viewModel.reminder.title)
                .foregroundColor(.accentColor)
                .bold()
                .font(.largeTitle)
        }
        .padding(.horizontal, 50)
    }
}
