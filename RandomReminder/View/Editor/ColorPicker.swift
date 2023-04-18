//
//  ColorPicker.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/13/23.
//

import Foundation
import SwiftUI

struct ColorPicker: View {
    @ObservedObject var viewModel: EditorViewModel
    
    var body: some View {
        HStack {
            Pagination(spacing: 10, selected: $viewModel.reminder.colorChoice) {
                ForEach(0..<8, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Reminder.colors[index % 8])
                        .frame(width: 100, height: 100)
                        .padding(10)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                withAnimation {
                                    viewModel.select(index)
                                }
                            }
                        }
                }
            } frame: {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.background, lineWidth: 3)
            }
            Spacer()
        }
    }
    
}
