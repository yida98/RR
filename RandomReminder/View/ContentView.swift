//
//  ContentView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/20/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @State var isOpen: Bool = false
    @Namespace var bellButton
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: -20) {
                RemindersView(viewModel: viewModel, isOpen: $isOpen)
                Button {
                    withAnimation {
                        isOpen.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.frequent)
                            .frame(width: 50, height: 50)
                        if isOpen {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.accentColor)
                                .matchedGeometryEffect(id: "label", in: bellButton)
                        } else {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.accentColor)
                                .matchedGeometryEffect(id: "label", in: bellButton)
                        }
                    }
                }
                .buttonStyle(DimensionalButtonStyle(baseShape: Circle()))
                .animation(.spring(), value: isOpen)
                Group {
                    if isOpen {
                        DetailAdjustmentView(viewModel: viewModel.getEditorViewModel())
                    }
                }
                .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                .animation(.spring(), value: isOpen)

                Spacer()
            }
            Spacer()
        }
        .background(Color.baseColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
