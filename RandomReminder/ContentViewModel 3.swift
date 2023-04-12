//
//  ContentViewModel.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    func getEditorViewModel() -> EditorViewModel {
        return EditorViewModel()
    }
}
