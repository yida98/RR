//
//  ColorPicker.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/13/23.
//

import Foundation
import SwiftUI
import Combine

struct ColorPicker: View {
    @ObservedObject var viewModel: EditorViewModel
    @State private var readSelection: Int
    @State private var isDragging: Bool = false
    
    static private var frameScale = Constant.screenBounds.height / 12
    private var frameSize = CGSize(width: ColorPicker.frameScale, height: ColorPicker.frameScale)
    private var cellSizeL = CGSize(width: ColorPicker.frameScale - 20, height: ColorPicker.frameScale - 20)
    private var cellSizeS = CGSize(width: ColorPicker.frameScale - 30, height: ColorPicker.frameScale - 30)
    
    // MARK: - Emoji
    @FocusState var isTyping: Bool
        
    init(viewModel: EditorViewModel) {
        self.viewModel = viewModel
        self._readSelection = .init(initialValue: viewModel.reminder.colorChoice)
        
        UIToolbar.appearance().setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        UIToolbar.appearance().clipsToBounds = true
    }
    
    var body: some View {
        HStack {
            ZStack {
                GeometryReader { proxy in
                    Pagination(draggingProxy: $isDragging, spacing: 10, selected: $readSelection) {
                        ForEach(0..<8, id: \.self) { index in
                            Color.clear
                                .frame(width: frameSize.width, height: frameSize.height)
                                .overlay {
                                    RoundedRectangle(cornerRadius: cellSizeL.width / 3.5)
                                        .fill(Reminder.colors[index % 8])
                                        .frame(width: readSelection == index ? cellSizeL.width : cellSizeS.width,
                                               height: readSelection == index ? cellSizeL.height : cellSizeS.height)
                                        .padding(readSelection == index ? 10 : 20)
                                        .opacity(opacity(at: index))
                                        .animation(.linear, value: readSelection)
                                        .animation(.linear, value: viewModel.shouldDim)
                                }
                                .onTapGesture {
                                    DispatchQueue.main.async {
                                        withAnimation(.linear) {
                                            select(index)
                                        }
                                    }
                                }
                        }
                    } frame: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .bold()
                                .foregroundColor(.background)
                                .onTapGesture {
                                    select(max(readSelection - 1, 0))
                                    manualDim()
                                }
                            RoundedRectangle(cornerRadius: cellSizeL.width / 2.5)
                                .stroke(Color.background, lineWidth: 2)
                                .frame(width: frameSize.width, height: frameSize.height)
                                .fixedSize()
                            Image(systemName: "chevron.right")
                                .bold()
                                .foregroundColor(.background)
                                .onTapGesture {
                                    select(min(readSelection + 1, 7))
                                    manualDim()
                                }
                        }
                    }
                    .coordinateSpace(name: "Pager")
                    .frame(width: frameSize.width, height: frameSize.height)
                    .onChange(of: readSelection) { newValue in
                        select(newValue)
                        let impactHeptic = UIImpactFeedbackGenerator(style: .light)
                        impactHeptic.impactOccurred()
                    }
                    .onChange(of: isDragging) { newValue in
                        viewModel.shouldDim = false
                        viewModel.isDraggingPublisher.send(newValue)
                    }
                }
                                
                TextField("☺︎", text: $viewModel.reminder.icon)
                    .font(.largeTitle)
                    .bold()
                    .focused($isTyping)
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
                    .onChange(of: viewModel.reminder.icon) { newValue in
                        if let last = newValue.last {
                            viewModel.reminder.icon = String(last)
                            isTyping.toggle()
                        }
                    }
                    .submitLabel(.done)
            }
            .frame(width: frameSize.width, height: frameSize.height)
            Spacer()
        }
        .padding(.horizontal, 40)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down.fill")
                        .foregroundColor(.background)
                        .padding(4)
                        .padding(.horizontal, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.baseColor)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white)
                                }
                            
                        )
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    
    private func opacity(at index: Int) -> Double {
        if readSelection == index {
            return 1.0
        } else {
            return viewModel.shouldDim ? 0 : 0.5
        }
    }
    
    private func select(_ index: Int) {
        readSelection = index
        viewModel.select(index)
    }
    
    private func manualDim() {
        viewModel.shouldDim = false
        viewModel.isDraggingPublisher.send(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            viewModel.isDraggingPublisher.send(false)
        }
    }
}
