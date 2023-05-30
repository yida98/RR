//
//  FrequencySlider.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct FrequencySlider: View {
    @GestureState var dragLocation: CGPoint = .zero
    @Binding var currentFrequency: Int
    var baseColor: Color
    
    init(currentFrequency: Binding<Int>, baseColor: Color = .bombardment) {
        self._currentFrequency = currentFrequency
        self.baseColor = baseColor
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { frequency in
                getShape(for: frequency)
                    .fill(getFill(for: frequency))
                    .id(frequency)
                    .background(dragObserver(frequency))
                    .onTapGesture {
                        updateFrequency(frequency)
                    }
            }
        }
        .highPriorityGesture(
            DragGesture(coordinateSpace: .global)
                .updating($dragLocation, body: { value, state, transaction in
                    state = value.location
                })
        )
    }
    
    private func getShape(for frequency: Int) -> some Shape {
        if frequency == 0 {
            return IrregularParallelogram(position: .left)
        } else if frequency >= 4 {
            return IrregularParallelogram(position: .right)
        } else {
            return IrregularParallelogram(position: .centre)
        }
    }
    
    private func getFill(for frequency: Int) -> some ShapeStyle {
        return frequency <= currentFrequency ? baseColor.opacity(Double((Double(frequency + 1) / Double(10)) + 0.5)) : Color.neutral.opacity(0.5)
    }
    
    private func dragObserver(_ id: Int) -> some View {
        GeometryReader { proxy in
            if proxy.frame(in: .global).contains(dragLocation) {
                updateFrequency(id)
            }
            return Rectangle().fill(Color.clear)
        }
    }
    
    private func updateFrequency(_ frequency: Int) {
        if currentFrequency != frequency {
            DispatchQueue.main.async {
                self.currentFrequency = (frequency)
            }
            let impactHeptic = UIImpactFeedbackGenerator(style: .light)
            impactHeptic.impactOccurred()
        }
    }
}

struct IrregularParallelogram: Shape {
    var position: IrregularParallelogram.Position
    
    func path(in rect: CGRect) -> Path {
        let radius = rect.height / 2
        
        switch position {
        case .left:
            return leftPath(for: rect, radius: radius)
        case .centre:
            return centrePath(for: rect, radius: radius)
        case .right:
            return rightPath(for: rect, radius: radius)
        }
    }
    
    private func leftPath(for rect: CGRect, radius: CGFloat) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.maxY))
        path.addLine(to: CGPoint(x: radius, y: rect.maxY))
        
        path.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: Angle.radians((Double.pi / 2)), endAngle: Angle.radians(-(Double.pi / 2)), clockwise: false)
        
        return path
    }
    
    private func centrePath(for rect: CGRect, radius: CGFloat) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: radius, y: rect.minY))
        
        return path
    }
    
    private func rightPath(for rect: CGRect, radius: CGFloat) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: radius), radius: radius, startAngle: Angle.radians(-(Double.pi / 2)), endAngle: Angle.radians(Double.pi / 2), clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: radius, y: rect.minY))
        
        return path
    }
    
    enum Position {
        case left, centre, right
    }
}
