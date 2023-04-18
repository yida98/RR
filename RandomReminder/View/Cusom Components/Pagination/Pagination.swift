//
//  Pagination.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/6/23.
//

import Foundation
import SwiftUI

struct Pagination<Content: View, Frame: View>: View {
    @GestureState private var dragOffset: CGSize = .zero
    @GestureState private var isDragging: Bool = false
    @State var baseOffset: CGFloat = .zero
    @State var realOffset_x: CGFloat = .zero
    
    private var spacing: CGFloat
    private var clipped: Bool
    
    private var frame: Frame
    @State var maxSize: CGSize = CGSize(width: 1, height: 1)
    @Binding var selected: Int
    
    
    private let children: [AnyView]
    
    init(spacing: CGFloat = 0, selected: Binding<Int>, clipped: Bool = true, @ViewBuilder _ content: () -> Content, @ViewBuilder frame: (() -> Frame) = { EmptyView() }) {
        self.spacing = spacing
        self.clipped = clipped
        self.frame = frame()
        self._selected = selected
        
        if let content = content() as? Decomposable {
            self.children = content.decompose()
        } else {
            self.children = content().getSubviews()
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                PaginationLayout(spacing: spacing) {
                    ForEach(children.indices, id: \.self) { index in
                        getChild(at: index)
                            .locationIsInView($selected, id: index, frame: proxy.frame(in: .global))
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onChange(of: proxy.frame(in: .global)) { newValue in
                                            if maxSize.width < proxy.size.width {
                                                maxSize = proxy.size
                                                scroll(cellSize: maxSize)
                                            }
                                        }
                                }
                            )
                    }
                    .offset(x: realOffset_x)
                }
                .frame(width: maxSize.width, height: maxSize.height)
                .overlay {
                    frame
                }
                .onChange(of: isDragging) { newValue in
                    if !newValue {
                        withAnimation {
                            scroll(cellSize: maxSize)
                        }
                    }
                }
            }
        }
        .frame(width: maxSize.width, height: maxSize.height)
        .gesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .global)
                .updating($dragOffset, body: { value, state, transaction in
                    withAnimation {
                        let translation = value.decreasingTranslation(limit: getTotalCellSize(from: maxSize))
                        DispatchQueue.main.async {
                            self.realOffset_x = self.baseOffset + translation.width
                        }
                        state = translation
                    }
                })
                .updating($isDragging, body: { value, state, transaction in
                    state = true
                })
        )
    }
    
    func getChild(at index: Int) -> AnyView {
        children[index]
    }
    
    // MARK: Offset calculations
    
    func getTotalCellSize(from cellSize: CGSize) -> CGSize {
        var size = cellSize
        size.width += spacing
        size.height += spacing
        return size
    }
    
    func getTotalFrameWidth(with cellSize: CGSize) -> CGFloat {
        CGFloat((cellSize.width * CGFloat(children.count)) + (spacing * CGFloat(children.count - 1)))
    }
    
    func scroll(cellSize: CGSize) {
        let totalWidth = getTotalFrameWidth(with: cellSize)
        let offset = Pagination.baseOffset_x(at: selected, frameWidth: getTotalCellSize(from: cellSize).width, totalWidth: totalWidth)
        baseOffset = offset
        realOffset_x = offset
        print(getTotalCellSize(from: cellSize).width , totalWidth, offset)
    }
    
    static func baseOffset_x(at selection: Int, frameWidth: CGFloat, totalWidth: CGFloat) -> CGFloat {
        CGFloat(selection) * -frameWidth
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
