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
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: -20) {
                RemindersView(isOpen: $isOpen)
                Button {
                    withAnimation {
                        isOpen.toggle()
                    }
                } label: {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                }
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
