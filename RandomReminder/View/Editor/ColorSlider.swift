//
//  ColorSlider.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import SwiftUI
import Combine

struct ColorSlider: View {
    @ObservedObject var viewModel: EditorViewModel
    
    // MARK: - Color slider
    @State private var isUpdating: Bool = false
    var padding: CGFloat
    private let scrollCoordinateSpace = "scroll"
    @State var prevXOffset: CGFloat = 0
    
    // MARK: - Emoji
    @FocusState var isTyping: Bool
    
    init(viewModel: EditorViewModel, padding: CGFloat) {
        self.viewModel = viewModel
        self.padding = padding
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollProxy in
                ZStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(0..<8, id: \.self) { index in
                                ColorCell(viewModel: viewModel, index: index, isUpdating: $isUpdating)
                                    .onTapGesture {
                                        scroll(to: index, with: scrollProxy, geometryProxy)
                                    }
                            }
                        }
                        .padding(.trailing, Constant.screenBounds.width - 90)
                        .padding(.leading, padding)
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                value: -$0.frame(in: .named(scrollCoordinateSpace)).origin.x)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) {
                            viewModel.onEnd.send($0)
                            if prevXOffset != $0 {
                                viewModel.onChange.send($0)
                            }
                        }
                    }
                    .coordinateSpace(name: scrollCoordinateSpace)
                    .onReceive(viewModel.onEnd
                        .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
                        .dropFirst()
                        .eraseToAnyPublisher()) { xOffset in
                        DispatchQueue.main.async {
                            scroll(to: Int(viewModel.reminder.colorChoice), with: scrollProxy, geometryProxy)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                /// Delay is required because of sprint animation from above (0.55 minimum)
                                self.isUpdating = false
                            }
                        }
                    }
                    .onReceive(viewModel.onChange.eraseToAnyPublisher()) { xOffset in
                        prevXOffset = xOffset
                        if !isUpdating {
                            DispatchQueue.main.async {
                                self.isUpdating = true
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            scrollProxy.scrollTo(viewModel.reminder.colorChoice, anchor: self.anchorUnitPoint(for: geometryProxy))
                            self.isUpdating = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            scrollProxy.scrollTo(viewModel.reminder.colorChoice, anchor: self.anchorUnitPoint(for: geometryProxy))
                            self.isUpdating = false
                        }
                    }
                
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundColor(.background)
                            .frame(width: 20)
                            .onTapGesture {
                                if viewModel.reminder.colorChoice - 1 >= 0 {
                                    scroll(to: Int(viewModel.reminder.colorChoice) - 1, with: scrollProxy, geometryProxy)
                                }
                            }
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.background, lineWidth: 4)
                                .frame(width: 70, height: 70)
                            TextField("☺︎", text: $viewModel.reminder.icon)
                                .font(.largeTitle)
                                .bold()
                                .focused($isTyping)
                                .foregroundColor(.accentColor)
                                .multilineTextAlignment(.center)
                                .frame(width: 70, height: 70)
                                .onChange(of: viewModel.reminder.icon) { newValue in
                                    if let last = newValue.last {
                                        viewModel.reminder.icon = String(last)
                                        isTyping.toggle()
                                    }
                                }
                        }.frame(width: 74, height: 74)
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundColor(.background)
                            .frame(width: 20)
                            .onTapGesture {
                                if viewModel.reminder.colorChoice + 1 < 8 {
                                    scroll(to: Int(viewModel.reminder.colorChoice) + 1, with: scrollProxy, geometryProxy)
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
    
    private func scroll(to index: Int, with scrollProxy: ScrollViewProxy, _ geometryProxy: GeometryProxy) {
        DispatchQueue.main.async {
            viewModel.select(index)
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

public extension UITextField
{
    override var textInputMode: UITextInputMode?
    {
        let locale = Locale(identifier: "emoji")
        
        return
            UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.identifier })
            ??
            super.textInputMode
    }
}
