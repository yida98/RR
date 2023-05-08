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
                    .shadow(radius: 10)
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
        .unintrusiveAlert(trigger: !appData.authorization) {
            VStack(spacing: 4) {
                Text("Notifications disabled.")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button {
                    UIApplication.shared.openSettings()
                } label: {
                    Text("Settings")
                        .font(.caption)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.thinMaterial))
                }
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10).fill(.thickMaterial).shadow(radius: 5))
        }
    }
}

extension View {
    func unintrusiveAlert<Alert: View>(trigger: Bool, @ViewBuilder _ alertView: () -> Alert) -> some View {
        modifier(UnintrusiveAlert(trigger: trigger, alertView: alertView()))
    }
}

struct UnintrusiveAlert<Alert: View>: ViewModifier {
    let trigger: Bool
    let alertView: Alert
    func body(content: Content) -> some View {
        ZStack {
            content
            if trigger {
                VStack {
                    alertView.transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
                    Spacer()
                }.padding()
            }
        }
    }
}
