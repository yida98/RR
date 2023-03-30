//
//  DimensionalButtonStyle.swift
//  RandomReminder
//
//  Created by Yida Zhang on 3/29/23.
//

import Foundation
import SwiftUI

struct DimensionalButtonStyle<S: Shape>: ButtonStyle {
    var baseShape: S
    
    init(baseShape: S) {
        self.baseShape = baseShape
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(y: configuration.isPressed ? 0 : -4)
            .overlay {
                baseShape
                    .stroke(Color.accentColor, lineWidth: 2)
                    .offset(y: configuration.isPressed ? 0 : -4)
            }
        
            .background(
                baseShape
                    .fill(Color.accentColor)
                    .overlay {
                        baseShape.stroke(Color.accentColor, lineWidth: 2)
                    }
            )
            .animation(nil, value: configuration.isPressed)
    }
}
