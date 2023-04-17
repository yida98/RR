//
//  Pagination.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/6/23.
//

import Foundation
import SwiftUI

struct Pagination<Content: View, Frame: View>: View {
    @ObservedObject var coordinator: PaginationCoordinator
    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var isDragging: Bool = false
    
    private var clipped: Bool
    
    private var frame: Frame
    
    init(selected: Binding<Int>, clipped: Bool = true, @ViewBuilder _ content: () -> Content, @ViewBuilder frame: (() -> Frame) = { EmptyView() }) {
        self.clipped = clipped
        self.coordinator = PaginationCoordinator(selected: selected, content)
        
        self.frame = frame()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(coordinator.children.count)")
                Text("\(coordinator.maxSize.height)")
                Text("\(coordinator.maxSize.width)")
                Text("\(coordinator.selected)")
            }
            GeometryReader { proxy in
                PaginationLayout(maxSize: $coordinator.maxSize) {
                    ForEach(coordinator.children.indices, id: \.self) { index in
                        coordinator.getChild(at: index)
                            .tag(index)
                            .locationIsInView($coordinator.selected, id: index, frame: proxy.frame(in: .global))
                    }
                    .offset(x: coordinator.realOffset_x)
                }
                .frame(width: coordinator.maxSize.width, height: coordinator.maxSize.height)
                .overlay {
                    frame
                }
                .onChange(of: isDragging) { newValue in
                    if !newValue {
                        withAnimation {
                            coordinator.scroll()
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .gesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .global)
                .updating($dragOffset, body: { value, state, transaction in
                    withAnimation {
                        let translation = value.decreasingTranslation(limit: coordinator.maxSize)
                        DispatchQueue.main.async {
                            self.coordinator.realOffset_x = self.coordinator.baseOffset + translation.width
                        }
                        state = translation
                    }
                })
                .updating($isDragging, body: { value, state, transaction in
                    state = true
                })
        )
    }
}

extension DragGesture.Value {
    func decreasingTranslation(limit: CGSize) -> CGSize {
        // y = ((limit * 2) / pi) * arctan((pi * x) / limit)
        
        let x_directional_multiplier: CGFloat = self.translation.width >= 0 ? 1 : -1
        let y_directional_multiplier: CGFloat = self.translation.height >= 0 ? 1 : -1
        
        let x_multiplier = CGFloat((limit.width * 2.0) / Double.pi) * atan((self.translation.width.magnitude * Double.pi) / limit.width)
        let y_multiplier = CGFloat((limit.height * 2.0) / Double.pi) * atan((self.translation.height.magnitude * Double.pi) / limit.height)
        
        let newWidth = x_directional_multiplier * min(x_multiplier, limit.width)
        let newHeight = y_directional_multiplier * min(y_multiplier, limit.height)
        
        return CGSize(width: newWidth, height: newHeight)
    }
}

extension View {
    func locationIsInView<Tag: Hashable>(_ selected: Binding<Tag>, id: Tag, frame: CGRect) -> some View {
        modifier(LocationReader(selected: selected, id: id, frame: frame))
    }
}

struct LocationReader<Tag: Hashable>: ViewModifier {
    @Binding var selected: Tag
    let id: Tag
    let frame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.frame(in: .global)) { newValue in
                            let point = CGPoint(x: newValue.midX, y: newValue.midY)
                            if frame.contains(point) {
                                DispatchQueue.main.async {
                                    selected = id
                                }
                            }
                        }
                }
            )
    }
}
