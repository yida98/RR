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
    @Published var selected: Int = 0
    @Published var maxSize: CGSize = .zero
    @Published var baseOffset: CGFloat = .zero
    @Published var real_x_offset: CGFloat = .zero
    let children: [AnyView]
    private var subscriber = Set<AnyCancellable>()
    
    init<Content: View>(@ViewBuilder _ content: () -> Content) {
        self.children = content().getSubviews()

        $maxSize.sink { [weak self] newValue in
            guard let strongSelf = self, newValue != strongSelf.maxSize else { return }
            let currentOffset = PaginationCoordinator.baseOffset_x(at: strongSelf.selected, frameWidth: newValue.width, totalWidth: newValue.width * CGFloat(strongSelf.children.count))
            strongSelf.baseOffset = currentOffset
            strongSelf.real_x_offset = currentOffset
        }.store(in: &subscriber)
    }
    
    func scroll() {
        let offset = PaginationCoordinator.baseOffset_x(at: selected, frameWidth: maxSize.width, totalWidth: maxSize.width * CGFloat(children.count))
        baseOffset = offset
        real_x_offset = offset
    }
    
    static func baseOffset_x(at selection: Int, frameWidth: CGFloat, totalWidth: CGFloat) -> CGFloat {
        let widthDeficit: CGFloat = (totalWidth / 2.0)
        
        let rawOffset = CGFloat(selection) * -frameWidth - (frameWidth / 2)
        let result = rawOffset + widthDeficit
        
        print(widthDeficit, rawOffset, result)
        return result
    }
    
    func getChild(at index: Int) -> AnyView {
        children[index]
    }
}
