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
    @Binding var maxSize: CGSize
    
    struct CacheData {
        var size: Size
    }
    
    func makeCache(subviews: Subviews) -> CacheData {
        let size = computeSizeParameters(proposal: .unspecified, subviews: subviews)
        return CacheData(size: size)
    }
    
    func updateCache(_ cache: inout CacheData, subviews: Subviews) {
        cache.size = computeSizeParameters(proposal: .unspecified, subviews: subviews)
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) -> CGSize {
        let size = computeSizeParameters(proposal: proposal, subviews: subviews)
        return CGSize(width: size.width, height: size.maxHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout CacheData) {
        var pt = CGPoint(x: bounds.midX, y: bounds.midY)
        
        for v in subviews {
            v.place(at: pt, anchor: .center, proposal: .unspecified)
            
//             pt.x += v.sizeThatFits(proposal).width + spacing
            pt.x += maxSize.width + spacing
        }
    }
    
    private func computeSizeParameters(proposal: ProposedViewSize, subviews: Subviews) -> Size {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        let maxWidth = sizes.reduce(sizes.first?.width ?? .zero) { max($0, $1.width) }
        
        let totalSpacing: CGFloat = spacing * (CGFloat(subviews.count) - 1)
        let maxHeight: CGFloat = sizes.reduce(.zero) { max($0, $1.height) }
        let trueWidth: CGFloat = sizes.reduce(.zero) { $0 + $1.width } + totalSpacing
        
        DispatchQueue.main.async {
            maxSize = CGSize(width: maxWidth, height: maxHeight)
        }
        
        return Size(maxHeight: maxHeight, width: trueWidth)
    }
    
    struct Size {
        var maxHeight: CGFloat
        var width: CGFloat
    }
}
