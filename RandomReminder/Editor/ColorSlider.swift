//
//  ColorSlider.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI
import Combine

struct ColorSlider: View {
    // MARK: - Color slider
    @State private var selectedRect: Int = 0
    @State private var isUpdating: Bool = false
    var padding: CGFloat
    private let onEnd: CurrentValueSubject<CGFloat, Never>
    private let onChange: CurrentValueSubject<CGFloat, Never>
    private let scrollCoordinateSpace = "scroll"
    
    // MARK: - Emoji
    @State var symbol: String = "A"
    
    init(padding: CGFloat) {
        self.padding = padding
        
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.onEnd = detector
        
        let constantEmission = CurrentValueSubject<CGFloat, Never>(0)
        self.onChange = constantEmission
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollProxy in
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(0..<8, id: \.self) { index in
                                ColorCell(selectedRect: $selectedRect, index: index, isUpdating: $isUpdating)
                                    .onTapGesture {
                                        scroll(to: index, with: scrollProxy, geometryProxy)
                                    }
                            }
                        }
                        .padding(.trailing, Constant.screenBounds.width - 50)
                        .padding(.leading, padding)
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named(scrollCoordinateSpace)).origin.x)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) {
                            onEnd.send($0)
                            onChange.send($0)
                        }
                    }
                    .coordinateSpace(name: scrollCoordinateSpace)
                    .onReceive(onEnd
                        .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
                        .dropFirst()
                        .eraseToAnyPublisher()) { xOffset in
                        DispatchQueue.main.async {
                            scroll(to: self.selectedRect, with: scrollProxy, geometryProxy)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                /// Delay is required because of sprint animation from above (0.55 minimum)
                                self.isUpdating = false
                            }
                        }
                    }
                    .onReceive(onChange.eraseToAnyPublisher()) { xOffset in
                        if !isUpdating {
                            DispatchQueue.main.async {
                                self.isUpdating = true
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            scrollProxy.scrollTo(self.selectedRect, anchor: self.anchorUnitPoint(for: geometryProxy))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                /// Delay is required because of transition animation
                                self.isUpdating = false
                            }
                        }
                    }
                
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundColor(.background)
                            .frame(width: 20)
                            .onTapGesture {
                                if self.selectedRect - 1 >= 0 {
                                    scroll(to: self.selectedRect - 1, with: scrollProxy, geometryProxy)
                                }
                            }
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.background, lineWidth: 4)
                                .frame(width: 70, height: 70)
                            EmojiTextField(text: $symbol, placeholder: "☺︎")
                                .frame(width: 70, height: 70)
                        }.frame(width: 74, height: 74)
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundColor(.background)
                            .frame(width: 20)
                            .onTapGesture {
                                if self.selectedRect + 1 < 8 {
                                    scroll(to: self.selectedRect + 1, with: scrollProxy, geometryProxy)
                                }
                            }
                        Spacer()
                    }
                    .padding(.leading, padding - 20)
                }
            }
        }
        .frame(height: 74)
    }
    
    private func anchorUnitPoint(for geometryProxy: GeometryProxy) -> UnitPoint {
        let x = 1.0 - ((geometryProxy.size.width - (padding + 10)) / geometryProxy.size.width)
        let y = 0.0
        return UnitPoint(x: x, y: y)
    }
    
    private func select(_ index: Int) {
        selectedRect = index
    }
    
    private func scroll(to index: Int, with scrollProxy: ScrollViewProxy, _ geometryProxy: GeometryProxy) {
        select(index)
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                scrollProxy.scrollTo(index, anchor: self.anchorUnitPoint(for: geometryProxy))
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
