//
//  ContentView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/20/23.
//

import SwiftUI

struct ContentView: View {
    @State var isOpen: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: -20) {
                RemindersView(isOpen: $isOpen)
                Button {
                    isOpen.toggle()
                } label: {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                }
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
