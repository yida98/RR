//
//  DaySelector.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/21/23.
//

import SwiftUI

struct DaySelector: View {
    @State var daysSelected = [false, false, false, false, false, false, false]
    let days = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        HStack {
            ForEach(days.indices, id: \.self) { index in
                Text(days[index])
                    .strokedText(daysSelected[index])
                    .frame(maxWidth: .infinity)
                    .font(.body.weight(.heavy))
                    .foregroundColor(daysSelected[index] ? .accentColor : .black)
                    .onTapGesture {
                        daysSelected[index] = !daysSelected[index]
                    }
            }
        }
    }
}

struct DaySelector_Previews: PreviewProvider {
    static var previews: some View {
        DaySelector()
            .background(Color.baseColor)
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
