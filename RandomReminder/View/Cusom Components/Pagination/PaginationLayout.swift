//
//  PaginationLayout.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/12/23.
//

import Foundation
import SwiftUI

struct PaginationLayout: Layout {
    let spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = computeSizeParameters(proposal: proposal, subviews: subviews)
        return CGSize(width: size.width, height: size.maxHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var pt = CGPoint(x: bounds.midX, y: bounds.midY)
        let size = computeSizeParameters(proposal: proposal, subviews: subviews)
        
        for v in subviews {
            v.place(at: pt, anchor: .center, proposal: proposal)

//             pt.x += v.sizeThatFits(proposal).width + spacing
            pt.x += size.cellSize.width + spacing
        }
    }
    
    private func computeSizeParameters(proposal: ProposedViewSize, subviews: Subviews) -> Size {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        
        let maxWidth = sizes.reduce(sizes.first?.width ?? .zero) { max($0, $1.width) }
        
        let totalSpacing: CGFloat = spacing * (CGFloat(subviews.count) - 1)
        let maxHeight: CGFloat = sizes.reduce(.zero) { max($0, $1.height) }
        let trueWidth: CGFloat = sizes.reduce(.zero) { $0 + $1.width } + totalSpacing
        
        return Size(maxHeight: maxHeight, width: trueWidth, cellSize: CGSize(width: maxWidth, height: maxHeight))
    }
    
    struct Size {
        var maxHeight: CGFloat
        var width: CGFloat
        var cellSize: CGSize
    }
}
