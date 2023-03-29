//
//  EmojiTextField.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import Foundation
import UIKit
import SwiftUI

class UIEmojiTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var textInputContextIdentifier: String? { "" }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default // do not remove this
                return mode
            }
        }
        return nil
    }
}

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    
    func makeUIView(context: Context) -> UIEmojiTextField {
        let emojiTextField = UIEmojiTextField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        emojiTextField.textAlignment = .center
        emojiTextField.textColor = UIColor.white
        emojiTextField.returnKeyType = .done
        emojiTextField.delegate = context.coordinator
        return emojiTextField
    }
    
    func updateUIView(_ uiView: UIEmojiTextField, context: Context) {
        
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        private var uncommittedChange: String?
        
        init(parent: EmojiTextField) {
            self.parent = parent
            self.uncommittedChange = parent.text
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            uncommittedChange = textField.text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let rawText = textField.text
            if var text = rawText {
                if text.count > 1 {
                    text = String(text.last!)
                }
                if text.count == 1, text != uncommittedChange {
                    DispatchQueue.main.async { [weak self] in
                        self?.parent.text = text
                        textField.resignFirstResponder()
                    }
                }
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}

struct EmojiContentView: View {
    
    @State private var text: String = ""
    
    var body: some View {
        EmojiTextField(text: $text, placeholder: "Enter emoji")
    }
}
