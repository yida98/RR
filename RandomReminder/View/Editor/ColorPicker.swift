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
    @State private var readSelection: Int = 0
    @State private var firstLaunch: Bool = true
    
    init(viewModel: EditorViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            GeometryReader { proxy in
                Pagination(spacing: 10, selected: $viewModel.reminder.colorChoice) {
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
                                    .animation(.linear, value: viewModel.hasEnded)
                            }
                            .background(
                                GeometryReader {
                                    Color.clear
                                        .locationIsInView($readSelection, id: index, frame: proxy.frame(in: .global))
                                        .preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("Pager")).origin.x)
                                }
                            )
                            .onPreferenceChange(ViewOffsetKey.self, perform: { newValue in
                                viewModel.onEnd.send(newValue)
                                DispatchQueue.main.async {
                                    self.viewModel.hasEnded = false
                                }
                            })
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    withAnimation(.linear) {
                                        viewModel.select(index)
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
                                viewModel.select(max(readSelection - 1, 0))
                            }
                        
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.background, lineWidth: 3)
                            .frame(width: 80, height: 80)
                            .fixedSize()
                        
                        Image(systemName: "chevron.right")
                            .bold()
                            .foregroundColor(.background)
                            .onTapGesture {
                                viewModel.select(min(readSelection + 1, 8))
                            }
                    }
                }
                .coordinateSpace(name: "Pager")
                .frame(width: 80, height: 80)
                .onChange(of: readSelection) { newValue in
                    let impactHeptic = UIImpactFeedbackGenerator(style: .light)
                    impactHeptic.impactOccurred()
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
            return viewModel.hasEnded ? 0 : 0.5
        }
    }
}
