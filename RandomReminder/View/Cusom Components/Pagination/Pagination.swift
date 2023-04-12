//
//  Pagination.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/6/23.
//

import Foundation
import SwiftUI

struct Pagination<Content: View>: View {
    @ObservedObject var coordinator: PaginationCoordinator
    @GestureState private var dragOffset: CGSize = .zero
    
    @State var maxSize: CGSize = .zero
    
    init(@ViewBuilder _ content: () -> Content) {
        self.coordinator = PaginationCoordinator(content)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(maxSize.height)")
                Text("\(maxSize.width)")
            }
            PaginationLayout(maxSize: $maxSize) {
                ForEach(coordinator.children.indices, id: \.self) { index in
                    coordinator.getChild(at: index)
                }
                .offset(x: dragOffset.width)
                .animation(.linear, value: dragOffset)
            }
            .frame(width: maxSize.width, height: maxSize.height)
            .background(
                Color.blue
            )
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .updating($dragOffset, body: { value, state, transaction in
                        state = value.translation
                    })
            )
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}


