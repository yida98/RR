//
//  EditorViewModel.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation
import Combine
import SwiftUI

class EditorViewModel: ObservableObject {
    
    // MARK: - Color slider
    
    let onEnd: PassthroughSubject<CGFloat, Never>
    let onChange: PassthroughSubject<CGFloat, Never>
    
    @Published var hasEnded: Bool = true
    @Published var reminder: DummyReminder
    @Published var isOnMorning: [Bool]
    @Published var isOnAfternoon: [Bool]
    var subscribers = Set<AnyCancellable>()
    
    init(reminder: Published<DummyReminder>) {
        // Color slider
        let detector = PassthroughSubject<CGFloat, Never>()
        self.onEnd = detector
        
        let constantEmission = PassthroughSubject<CGFloat, Never>()
        self.onChange = constantEmission
        
        self._reminder = reminder
        
        self.isOnMorning = [Bool]()
        self.isOnAfternoon = [Bool]()
        
        self.isOnMorning = Array(self.reminder.reminderTimeFrames[0..<12])
        self.isOnAfternoon = Array(self.reminder.reminderTimeFrames[12..<24])
        
        $isOnMorning
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .dropFirst()
            .sink {
                var newValues = $0
                newValues.append(contentsOf: self.isOnAfternoon)
                self.reminder.reminderTimeFrames = newValues
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
        
        $isOnAfternoon
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .dropFirst()
            .sink {
                var newValues = self.isOnMorning
                newValues.append(contentsOf: $0)
                self.reminder.reminderTimeFrames = newValues
                self.objectWillChange.send()
            }
            .store(in: &subscribers)
        
        onEnd
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .dropFirst()
            .sink { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.hasEnded = true
                }
            }
            .store(in: &subscribers)
    }
    
    func select(_ index: Int) {
        reminder.colorChoice = index
        self.objectWillChange.send()
    }
}
