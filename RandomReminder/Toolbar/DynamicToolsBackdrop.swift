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
            DynamicToolsBackdropShape(isOpen: $isOpen, proxy: proxy)
                .fill(Color.background)
                .animation(.linear, value: isOpen)
        }
    }
}

struct DynamicToolsBackdropShape: Shape {
    @Binding var isOpen: Bool
    private var divotY: CGFloat
    private var radius: CGFloat
    
    init(isOpen: Binding<Bool>, proxy: GeometryProxy) {
        self._isOpen = isOpen
        self.radius = proxy.size.width / 10
        self.divotY = isOpen.wrappedValue ? proxy.size.height + radius : proxy.size.height - radius
    }
    
    var animatableData: CGFloat {
        get {
            divotY
        }
        set {
            divotY = newValue
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
        let bottomControlY = rect.maxY - radius
        path.addLine(to: CGPoint(x: rect.maxX, y: bottomControlY))
        path.addArc(center: CGPoint(x: rightControlX, y: bottomControlY),
                    radius: radius,
                    startAngle: Angle.zero,
                    endAngle: Angle.radians(Double.pi / 2),
                    clockwise: false)
        
        /// Bottom line
        let leftControlX = radius
        path.addLine(to: CGPoint(x: rect.midX + (2 * radius), y: rect.maxY))
        
        path.addCurve(to: CGPoint(x: rect.midX, y: divotY),
                      control1: CGPoint(x: rect.midX + radius, y: rect.maxY),
                      control2: CGPoint(x: rect.midX + radius, y: divotY))
        path.addCurve(to: CGPoint(x: rect.midX - (2 * radius), y: rect.maxY),
                      control1: CGPoint(x: rect.midX - radius, y: divotY),
                      control2: CGPoint(x: rect.midX - radius, y: rect.maxY))
        
        path.addLine(to: CGPoint(x: leftControlX, y: rect.maxY))
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
