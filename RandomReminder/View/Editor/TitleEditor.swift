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
    @FocusState var isTyping: Bool
    @State var showTextField: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("TITLE")
                    .subtitle()
                Spacer()
            }
            .frame(height: 20)

            if showTextField {
                TextField("Title", text: $viewModel.reminder.title)
                    .foregroundColor(.accentColor)
                    .bold()
                    .font(.largeTitle)
                    .frame(height: 50)
                    .focused($isTyping)
                    .multilineTextAlignment(.leading)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(viewModel.reminder.title)
                        .foregroundColor(.accentColor)
                        .bold()
                        .font(.largeTitle)
                        .frame(height: 50)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }.onTapGesture {
                    showTextField = true
                }
            }
        }
        .padding(.horizontal, 50)
        .onChange(of: showTextField) { newValue in
            if newValue {
                isTyping = true
            }
        }
        .onChange(of: isTyping) { newValue in
            if !newValue {
                showTextField = false
            }
        }
    }
}
