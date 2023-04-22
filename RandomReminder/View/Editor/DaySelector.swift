//
//  DaySelector.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/21/23.
//

import SwiftUI

struct DaySelector: View {
    @Binding var daysSelected: [Bool]
    static let days = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        HStack {
            ForEach(DaySelector.days.indices, id: \.self) { index in
                Text(DaySelector.days[index])
                    .strokedText(daysSelected[index])
                    .frame(maxWidth: .infinity)
                    .font(.body.weight(.heavy))
                    .foregroundColor(daysSelected[index] ? .accentColor : .black)
                    .onTapGesture {
                        daysSelected[index] = !daysSelected[index]
                        let impactHeptic = UIImpactFeedbackGenerator(style: .light)
                        impactHeptic.impactOccurred()
                    }
            }
        }
    }
}

extension Text {
    func strokedText(_ on: Bool) -> some View {
        modifier(StrokedText(on: on))
    }
}

struct StrokedText: ViewModifier {
    var on: Bool
    
    func body(content: Content) -> some View {
        ZStack{
            if on {
                content.offset(x: -0.5, y: -0.3).foregroundStyle(.black)
            } else {
                content.offset(x: 0.5, y: 0.3).foregroundStyle(.ultraThinMaterial)
            }
            content
        }
    }
}
