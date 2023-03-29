//
//  EditorViewModel.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation
import Combine

class EditorViewModel: ObservableObject {
    
    // MARK: - Color slider
    
    let onEnd: CurrentValueSubject<CGFloat, Never>
    let onChange: PassthroughSubject<CGFloat, Never>
    
    init() {
        // Color slider
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.onEnd = detector
        
        let constantEmission = PassthroughSubject<CGFloat, Never>()
        self.onChange = constantEmission
    }
    
    
}
