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
        
    init(viewModel: EditorViewModel) {
        self.viewModel = viewModel
        self._readSelection = .init(initialValue: viewModel.reminder.colorChoice)
    }
    
    var body: some View {
        HStack {
            GeometryReader { proxy in
                Pagination(draggingProxy: $isDragging, spacing: 10, selected: $readSelection) {
                    ForEach(0..<8, id: \.self) { index in
                        Color.clear
                            .frame(width: 80, height: 80)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Reminder.colors[index % 8])
                                    .frame(width: readSelection == index ? 60 : 50,
                                           height: readSelection == index ? 60 : 50)
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
                            }
                        
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.background, lineWidth: 3)
                            .frame(width: 80, height: 80)
                            .fixedSize()
                        
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundColor(.background)
                            .onTapGesture {
                                select(min(readSelection + 1, 8))
                            }
                    }
                }
                .coordinateSpace(name: "Pager")
                .frame(width: 80, height: 80)
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
            .frame(width: 80, height: 80)
            Spacer()
        }
        .padding(.horizontal, 40)
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
}
