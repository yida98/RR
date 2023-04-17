//
//  PaginationCoordinator.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/11/23.
//

import Foundation
import SwiftUI
import Combine

class PaginationCoordinator: ObservableObject {
    @Binding var selected: Int
    @Published var maxSize: CGSize
    @Published var baseOffset: CGFloat = .zero
    @Published var realOffset_x: CGFloat = .zero
    let children: [AnyView]
    private var subscriber = Set<AnyCancellable>()
    
    init<Content: View>(selected: Binding<Int>, @ViewBuilder _ content: () -> Content) {
        if let content = content() as? Decomposable {
            self.children = content.decompose()
        } else {
            self.children = content().getSubviews()
        }
        self._selected = selected
        self.maxSize = .zero

        $maxSize.sink { [weak self] newValue in
            guard let strongSelf = self, newValue != strongSelf.maxSize else { return }
            let currentOffset = PaginationCoordinator.baseOffset_x(at: strongSelf.selected,
                                                                   frameWidth: newValue.width,
                                                                   totalWidth: newValue.width * CGFloat(strongSelf.children.count))
            strongSelf.baseOffset = currentOffset
            strongSelf.realOffset_x = currentOffset
        }.store(in: &subscriber)
    }
    
    func scroll() {
        let offset = PaginationCoordinator.baseOffset_x(at: selected, frameWidth: maxSize.width, totalWidth: maxSize.width * CGFloat(children.count))
        baseOffset = offset
        realOffset_x = offset
    }
    
    static func baseOffset_x(at selection: Int, frameWidth: CGFloat, totalWidth: CGFloat) -> CGFloat {
        CGFloat(selection) * -frameWidth
    }
    
    func getChild(at index: Int) -> AnyView {
        children[index]
    }
}
