//
//  RemindersView.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/21/23.
//

import SwiftUI

struct RemindersView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    @Binding var isOpen: Bool
    @Namespace var reminderNamespace
    
    var body: some View {
        ZStack {
            if isOpen {
                ReminderCell(reminder: $viewModel.reminderUnderConstruction)
                    .fixedSize(horizontal: false, vertical: true)
                    .matchedGeometryEffect(id: viewModel.reminderUnderConstruction.id, in: reminderNamespace)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(viewModel.reminders, id: \.id) { reminder in
                            makeReminderCell(for: reminder.id)
                                .onTapGesture {
                                    viewModel.setDummyReminder(reminder)
                                    withAnimation {
                                        isOpen = true
                                    }
                                }
                                .matchedGeometryEffect(id: reminder.id, in: reminderNamespace)
                        }
                    }
                }.transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
            }
            if viewModel.reminders.count == 0 && !isOpen {
                VStack {
                    Spacer(minLength: 0)
                    Image("tapHere")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 30)
                        .padding(.horizontal, 80)
                }
            }
        }
        .frame(width: Constant.screenBounds.width - 60)
        .padding(20)
        .background(DynamicToolsBackdrop(isOpen: $isOpen))
        .mask(DynamicToolsBackdrop(isOpen: $isOpen))
        .animation(.spring(), value: isOpen)
    }
    
    func makeReminderCell(for id: UUID?) -> some View {
        guard let id = id else { return AnyView(EmptyView()) }
        let binding = Binding<DummyReminder> {
            if let reminder = viewModel.reminders.first(where: { $0.id == id }) {
                return DummyReminder(reminder: reminder)
            }
            return DummyReminder()
        } set: { dummy, transaction in
            viewModel.updateReminder(id, reminder: dummy) 
        }

        return AnyView(ReminderCell(reminder: binding))
    }
}
