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
    
    let onEnd: CurrentValueSubject<CGFloat, Never>
    let onChange: PassthroughSubject<CGFloat, Never>
    
    @Published var reminder: DummyReminder
    
    init(reminder: Published<DummyReminder>) {
        // Color slider
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.onEnd = detector
        
        let constantEmission = PassthroughSubject<CGFloat, Never>()
        self.onChange = constantEmission
        
        self._reminder = reminder
    }
    
    func select(_ index: Int) {
        reminder.colorChoice = index
        self.objectWillChange.send()
    }
}
