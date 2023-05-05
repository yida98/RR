//
//  ContentView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/20/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appData: AppData
    
    @StateObject var viewModel = ContentViewModel()
    @State var isOpen: Bool = false
    @Namespace var bellButton
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: -20) {
                RemindersView(viewModel: viewModel, isOpen: $isOpen)
                Button {
                    appData.scheduleRandomReminders()
                    if isOpen {
                        viewModel.saveReminderUnderConstruction()
                    } else {
                        viewModel.makeNewReminder()
                    }
                    withAnimation {
                        isOpen.toggle()
                    }
                    
                    NotificationManager.shared.scheduleTestNotifications()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.frequent)
                            .frame(width: 50, height: 50)
                        if isOpen {
                            Image(systemName: "checkmark.circle")
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
                if isOpen {
                    DetailAdjustmentView(viewModel: viewModel.getEditorViewModel(), isOpen: $isOpen)
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                        .animation(.spring(), value: isOpen)
                        .environmentObject(appData)
                }

                Spacer()
            }
            Spacer()
        }
        .background(Color.baseColor.ignoresSafeArea())
    }
}
