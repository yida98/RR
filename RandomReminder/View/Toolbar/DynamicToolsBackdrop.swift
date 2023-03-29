//
//  DynamicToolsBackdrop.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct DynamicToolsBackdrop: View {
    @Binding var isOpen: Bool
    var body: some View {
        GeometryReader { proxy in
            DynamicToolsBackdropShape(isOpen: $isOpen, frameWidth: proxy.frame(in: .global).width, frameHeight: proxy.frame(in: .global).height)
                .fill(Color.background)
                .animation(.spring(), value: isOpen)
        }
    }
}

struct DynamicToolsBackdropShape: Shape {
    @Binding var isOpen: Bool
    private var frameWidth: CGFloat
    private var frameHeight: CGFloat
    private var divotY: CGFloat
    private var radius: CGFloat

    init(isOpen: Binding<Bool>, frameWidth: CGFloat, frameHeight: CGFloat) {
        self._isOpen = isOpen
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.radius = frameWidth / 10
        self.divotY = isOpen.wrappedValue ? frameHeight + radius : frameHeight - radius
    }
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatableData(divotY, frameHeight)
        }
        set {
            divotY = newValue.first
            frameHeight = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        /// Top line, no left corner
        let rightControlX = rect.maxX - radius
        
        path.move(to: CGPoint(x: radius, y: 0))
        path.addLine(to: CGPoint(x: rightControlX, y: 0))
        
        path.addArc(center: CGPoint(x: rightControlX, y: radius),
                    radius: radius,
                    startAngle: Angle.radians(-Double.pi / 2),
                    endAngle: Angle.zero,
                    clockwise: false)
        
        /// Right line, no corner
        let bottomControlY = frameHeight - radius
        path.addLine(to: CGPoint(x: rect.maxX, y: bottomControlY))
        path.addArc(center: CGPoint(x: rightControlX, y: bottomControlY),
                    radius: radius,
                    startAngle: Angle.zero,
                    endAngle: Angle.radians(Double.pi / 2),
                    clockwise: false)
        
        /// Bottom line
        let leftControlX = radius
        path.addLine(to: CGPoint(x: rect.midX + (2 * radius), y: frameHeight))
        
        path.addCurve(to: CGPoint(x: rect.midX, y: divotY),
                      control1: CGPoint(x: rect.midX + radius, y: frameHeight),
                      control2: CGPoint(x: rect.midX + radius, y: divotY))
        path.addCurve(to: CGPoint(x: rect.midX - (2 * radius), y: frameHeight),
                      control1: CGPoint(x: rect.midX - radius, y: divotY),
                      control2: CGPoint(x: rect.midX - radius, y: frameHeight))
        
        path.addLine(to: CGPoint(x: leftControlX, y: frameHeight))
        path.addArc(center: CGPoint(x: leftControlX, y: bottomControlY),
                    radius: radius,
                    startAngle: Angle.radians(Double.pi / 2),
                    endAngle: Angle.radians(Double.pi),
                    clockwise: false)
        
        /// Left line, no corner
        let topControlY = radius
        path.addLine(to: CGPoint(x: rect.minX, y: topControlY))
        path.addArc(center: CGPoint(x: leftControlX, y: topControlY),
                    radius: radius,
                    startAngle: Angle.radians(Double.pi),
                    endAngle: Angle.radians(-(Double.pi / 2)),
                    clockwise: false)
        
        return path
    }
}
