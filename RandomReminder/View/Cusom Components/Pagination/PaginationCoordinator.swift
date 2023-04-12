//
//  PaginationCoordinator.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/11/23.
//

import Foundation
import SwiftUI

class PaginationCoordinator: ObservableObject {
    let children: [AnyView]
    
    init<Content: View>(@ViewBuilder _ content: () -> Content) {
        self.children = content().getSubviews()
    }
    
    func getChild(at index: Int) -> AnyView {
        children[index]
    }
}

struct PaginationLayout: Layout {
    let spacing: CGFloat = 10
    @Binding var maxSize: CGSize
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let size = computeSizeParameters(proposal: proposal, subviews: subviews)
        return CGSize(width: size.width, height: size.maxHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var pt = CGPoint(x: bounds.minX, y: bounds.minY)
        
        for v in subviews {
            v.place(at: pt, anchor: .topLeading, proposal: proposal)
            
            pt.x += v.sizeThatFits(proposal).width + spacing
        }
    }
    
    private func computeSizeParameters(proposal: ProposedViewSize, subviews: Subviews) -> Size {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        
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
