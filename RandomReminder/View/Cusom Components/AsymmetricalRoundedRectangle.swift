//
//  AsymmetricalRoundedRectangle.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI

struct AsymmetricalRoundedRectangle: Shape {
    
    private var radii: AsymmetricalRoundedRectangle.Radii
    
    init(_ tlc: CGFloat, _ trc: CGFloat, _ brc: CGFloat, _ blc: CGFloat) {
        self.radii = AsymmetricalRoundedRectangle.Radii(tlc: tlc, trc: trc, brc: brc, blc: blc)
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tlc = min(radii.tlc, rect.maxX - radii.trc, rect.maxY - radii.blc)
        let trc = min(radii.trc, rect.maxX - radii.tlc, rect.maxY - radii.brc)
        let brc = min(radii.brc, rect.maxX - radii.blc, rect.maxY - radii.trc)
        let blc = min(radii.blc, rect.maxX - radii.brc, rect.maxY - radii.tlc)
        
        let tlControlX = tlc
        let tlControlY = tlc
        let trControlX = rect.maxX - trc
        let trControlY = trc
        let brControlX = rect.maxX - brc
        let brControlY = rect.maxY - brc
        let blControlX = blc
        let blControlY = rect.maxY - blc
        
        path.move(to: CGPoint(x: tlControlX, y: rect.minY))
        path.addLine(to: CGPoint(x: trControlX, y: rect.minY))
        
        path.addArc(center: CGPoint(x: trControlX, y: trControlY),
                    radius: trControlY,
                    startAngle: Angle(radians: -(Double.pi / 2)),
                    endAngle: Angle(radians: .zero),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: brControlY))
        
        path.addArc(center: CGPoint(x: brControlX, y: brControlY),
                    radius: brc,
                    startAngle: Angle(radians: .zero),
                    endAngle: Angle(radians: Double.pi / 2),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: blControlX, y: rect.maxY))
        
        path.addArc(center: CGPoint(x: blControlX, y: blControlY),
                    radius: blControlX,
                    startAngle: Angle(radians: Double.pi / 2),
                    endAngle: Angle(radians: Double.pi),
                    clockwise: false)
        
        path.addLine(to: CGPoint(x: rect.minX, y: tlControlY))
        
        path.addArc(center: CGPoint(x: tlControlX, y: tlControlY),
                    radius: tlControlX,
                    startAngle: Angle(radians: Double.pi),
                    endAngle: Angle(radians: -(Double.pi / 2)),
                    clockwise: false)
        
        return path
    }
    
    struct Radii {
        var tlc: CGFloat
        var trc: CGFloat
        var brc: CGFloat
        var blc: CGFloat
    }
}
