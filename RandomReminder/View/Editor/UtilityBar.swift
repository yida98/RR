//
//  UtilityBar.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/13/23.
//

import Foundation
import SwiftUI

struct UtilityBar: View {
    @ObservedObject var viewModel: EditorViewModel
    @Binding var isOpen: Bool
    
    @State private var offset: CGFloat = 5
    
    var body: some View {
            HStack {
                Text("Snooze")
                    .font(.subheadline)
                    .foregroundColor(.snooze)
                    .bold()
                    .frame(width: 80, height: 36)
                    .background {
                        AsymmetricalRoundedRectangle(10, 16, 16, 16)
                            .stroke(Color.snooze, lineWidth: 2)
                    }
                    .opacity(0.6)
                Spacer()
                VStack {
                    Spacer()
                    Text("▲")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accentColor)
                        .font(.caption)
                        .offset(y: offset)
                        .animation(.linear(duration: 0.4).repeatCount(7), value: offset)
                        .onAppear {
                            offset = 10
                        }
                }
                .fixedSize()
                .opacity(0.5)
                Spacer()
                Text("Delete")
                    .font(.subheadline)
                    .foregroundColor(.delete)
                    .bold()
                    .frame(width: 80, height: 36)
                    .background {
                        AsymmetricalRoundedRectangle(16, 10, 16, 16)
                            .stroke(Color.delete, lineWidth: 2)
                    }
                    .opacity(0.6)
                    .onTapGesture {
                        guard let id = viewModel.reminder.id else { return }
                        DataManager.shared.deleteReminder(with: id)
                        withAnimation {
                            isOpen = false
                        }
                    }
            }
            .padding(.horizontal, 30)
    }
}
