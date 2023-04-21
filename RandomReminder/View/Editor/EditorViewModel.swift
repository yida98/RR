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
    
    let isDraggingPublisher: PassthroughSubject<Bool, Never>
    let onEnd: PassthroughSubject<CGFloat, Never>
    let onChange: PassthroughSubject<CGFloat, Never>
    
    @Published var reminder: DummyReminder
    @Published var isOnMorning: [Bool]
    @Published var isOnAfternoon: [Bool]
    @Published var shouldDim: Bool = true
    var subscribers = Set<AnyCancellable>()
    
    init(reminder: Published<DummyReminder>) {
        // Color slider
        let detector = PassthroughSubject<Bool, Never>()
        self.isDraggingPublisher = detector
        
        let onEndDetector = PassthroughSubject<CGFloat, Never>()
        self.onEnd = onEndDetector
        
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
        
        isDraggingPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main).sink { newValue in
            if !newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.shouldDim = true
                    self.objectWillChange.send()
                }
            }
        }.store(in: &subscribers)
    }
    
    func select(_ index: Int) {
        reminder.colorChoice = index
        self.objectWillChange.send()
    }
}
