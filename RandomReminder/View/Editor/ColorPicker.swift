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
        Pagination(selected: $selected) {
            Text("1")
                .tag(0)
                .frame(width: 150)
                .background(Color.orange.opacity(0.5))
                .padding()
                .background(Color.orange.opacity(0.2))
            Text("2")
                .frame(width: 150)
                .background(Color.red.opacity(0.5))
            Image(systemName: "chevron.right")
                .frame(width: 150)
                .background(Color.yellow.opacity(0.5))
            Image(systemName: "chevron.right")
                .frame(width: 150)
                .background(Color.green.opacity(0.5))
            //                ForEach(0..<8, id: \.self) {index in
            //                    Circle()
            //                        .fill(Reminder.colors[index % 8])
            //                }
        } frame: {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue, lineWidth: 3)
        }
    }
    
}
