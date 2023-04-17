//
//  Decomposable.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/17/23.
//

import Foundation
import SwiftUI

protocol Decomposable {
    func decompose() -> [AnyView]
}

extension ForEach: Decomposable where Content: View {
    func decompose() -> [AnyView] {
        return data.map { AnyView(content($0)) }
    }
}

extension HStack: Decomposable {

    func decompose() -> [AnyView] {
        return [AnyView(self)]
    }

}

extension ZStack: Decomposable {

    func decompose() -> [AnyView] {
        return [AnyView(self)]
    }

}

extension VStack: Decomposable {

    func decompose() -> [AnyView] {
        return [AnyView(self)]
    }

}
