//
//  WaveLayout.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation
import SwiftUI

struct WaveLayout: Layout {
    let phase: Angle
    let frequency: Double
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = computeSizeParameters(proposal: proposal, subviews: subviews)
        
        return CGSize(width: proposal.width ?? size.width, height: proposal.height ?? size.maxHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let spacing = (bounds.width - (subviews.map { $0.sizeThatFits(proposal).width }.reduce(0) { $0 + $1 })) / CGFloat(subviews.count - 1)
        let amplitude: CGFloat = bounds.height / 2
        
        // Computer the container's total width
        let containerWidth = bounds.width
        
        // Initialized subviews anchor point
        var pt = CGPoint(x: bounds.minX, y: bounds.midY)
        
        for v in subviews {
            let viewSize = v.sizeThatFits(proposal)
            
            // The sinusoid is: y = sin(x) where x is an angle. For example, if
            // frequency = 2 and phase = 180°, then x would go from 180° to 900° (i.e., 180 + (2 x 360°))
            
            let sinusoid_x = Angle.degrees(frequency * 180) * ((pt.x - bounds.minX) / containerWidth) + phase
            let sinusoid_y = sin(sinusoid_x.radians)
            
            pt.y = bounds.midY + amplitude * sinusoid_y
            
            v.place(at: pt, anchor: .leading, proposal: proposal)

            // Advanced to next subview
            pt.x += viewSize.width + spacing
        }
    }
    
    private func computeSizeParameters(proposal: ProposedViewSize, subviews: Subviews) -> Size {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        
        let maxHeight: CGFloat = sizes.reduce(.zero) { max($0, $1.height) }
        let trueWidth: CGFloat = sizes.reduce(.zero) { $0 + $1.width }
        
        return Size(maxHeight: maxHeight, width: trueWidth)
    }
    
    struct Size {
        var maxHeight: CGFloat
        var width: CGFloat
    }
}
