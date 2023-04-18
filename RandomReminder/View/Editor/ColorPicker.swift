//
//  ColorPicker.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/13/23.
//

import Foundation
import SwiftUI

struct ColorPicker: View {
    @Binding var selected: Int
    
    var body: some View {
        Pagination(spacing: 20, selected: $selected) {
            ForEach(0..<8, id: \.self) { index in
                RoundedRectangle(cornerRadius: 20)
                    .fill(Reminder.colors[index % 8])
                    .frame(width: 50, height: 50)
                    .padding()
            }
        } frame: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue, lineWidth: 3)
        }
    }
    
}
