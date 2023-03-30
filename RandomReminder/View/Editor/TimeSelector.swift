//
//  TimeSelector.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import SwiftUI

struct TimeSelector: View {
    
    @State var isOn: [Bool] = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                WaveLayout(phase: Angle(radians: Double.pi / 2), frequency: 2) {
                    ForEach(0..<24) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isOn[index] ? .green : .green.opacity(0.5))
                            .frame(width: 8, height: isOn[index] ? 20 : 8)
                            .onTapGesture {
                                isOn[index].toggle()
                            }
                    }
                }
                Image(systemName: "sun.and.horizon")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, proxy.size.height / 2)
                    .foregroundColor(isAllDay() ? .green : .green.opacity(0.5))
                    .onTapGesture {
                        toggleAllIsOn()
                    }
            }
            .animation(.spring(), value: isOn)
        }
    }
    
    private func isAllDay() -> Bool {
        isOn.reduce(true) { $0 && $1 }
    }
    
    private func toggleAllIsOn() {
        let newValue = !isAllDay()
        var values = [Bool]()
        for _ in 0..<24 {
            values.append(newValue)
        }
        isOn = values
    }
}

struct TimeSelector_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelector()
    }
}
