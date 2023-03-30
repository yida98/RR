//
//  TimeSelector.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import SwiftUI

struct TimeSelector: View {
    
    @State var isOn: [Bool] = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
    @GestureState var dragLocation: CGPoint = .zero
    @State var direction: Bool?
    
    var systemImage: String
    var alignment: Edge.Set
    var phase: Angle
    var tint: Color = .green
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                WaveLayout(phase: phase, frequency: 2.2) {
                    ForEach(0..<12) { index in
                        Rectangle()
                            .fill(.clear)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isOn[index] ? tint : tint.opacity(0.5))
                                    .frame(width: 8, height: isOn[index] ? 20 : 8)
                            }
                            .onTapGesture {
                                direction = nil
                                isOn[index].toggle()
                            }
                            .background(dragObserver(id: index))
                            .frame(maxWidth: proxy.size.width / 12, idealHeight: 20)
                    }
                }
                .highPriorityGesture(
                    DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                        .updating($dragLocation, body: { value, state, transaction in
                            state = value.location
                        })
                        .onEnded({ value in
                            direction = nil
                        })
                )
                .onChange(of: isOn) { newValue in
                    let feedback = UIImpactFeedbackGenerator(style: .soft)
                    feedback.impactOccurred()
                }
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(alignment, proxy.size.height / 2)
                    .foregroundColor(isAllDay() ? tint : tint.opacity(0.5))
                    .onTapGesture {
                        toggleAllIsOn()
                    }
            }
            .animation(.easeOut(duration: 0.2), value: isOn)
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
        direction = nil
    }
    
    private func dragObserver(id: Int) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, id: id)
        }
    }
    
    private func dragObserver(geometry: GeometryProxy, id: Int) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                if direction == nil {
                    direction = !isOn[id]
                }
                isOn[id] = direction ?? !isOn[id]
            }
        }
        return Rectangle().fill(Color.clear)
      }
}

struct TimeSelector_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelector(systemImage: "cloud.moon", alignment: .top, phase: Angle(radians: Double.pi / 2))
    }
}
