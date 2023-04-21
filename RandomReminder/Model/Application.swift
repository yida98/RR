//
//  Application.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/28/23.
//

import Foundation
import UIKit

struct Constant {
    static let screenBounds: CGRect = UIWindow().screen.bounds
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
