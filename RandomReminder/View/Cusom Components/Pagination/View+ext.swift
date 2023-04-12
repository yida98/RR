//
//  View+ext.swift
//  RandomReminder
//
//  Created by Yida Zhang on 4/11/23.
//

import Foundation
import SwiftUI

extension View {
    func getSubviews() -> [AnyView] {
        func convert(child: Mirror.Child) -> AnyView? {
            withUnsafeBytes(of: child.value) { ptr -> AnyView? in
                let binded = ptr.bindMemory(to: GenericView.self)
                return (binded.first?.anyView)
            }
        }
        let type = String("\(type(of: self))")
        if type.contains("TupleView") {
            let mirror = Mirror(reflecting: self)
//            mirror.children.forEach { print("label: \($0.label), value: \($0.value)") }
            for child in mirror.children {
                let childMirror = Mirror(reflecting: child.value)
//                childMirror.children.forEach { print("label: \($0.label), value: \($0.value)") }
                return childMirror.children.compactMap { convert(child: $0) }
            }
        }
        return [AnyView(self)]
    }
    
    
    func getTag<TagType: Hashable>() throws -> TagType {
        // Mirror this view
        let mirror = Mirror(reflecting: self)

        // Get tag modifier
        guard let realTag = mirror.descendant("modifier", "value") else {
            // Not found tag modifier here, this could be composite
            // view. Check for modifier directly on the `body` if
            // not a primitive view type.
            guard Body.self != Never.self else {
                throw TagError.notFound
            }
            return try body.getTag()
        }

        // Bind memory to extract tag's value
        let fakeTag = try withUnsafeBytes(of: realTag) { ptr -> FakeTag<TagType> in
            let binded = ptr.bindMemory(to: FakeTag<TagType>.self)
            guard let mapped = binded.first else {
                throw TagError.other
            }
            return mapped
        }

        // Return tag's value
        return fakeTag.value
    }
}

internal struct GenericView {
    let body: Any
    
    var anyView: AnyView? {
        AnyView(_fromValue: body)
    }
}

public enum TagError: Error, CustomStringConvertible {
    case notFound
    case other

    public var description: String {
        switch self {
        case .notFound: return "Not found"
        case .other: return "Other"
        }
    }
}

internal enum FakeTag<TagType: Hashable> {
    case tagged(TagType)

    var value: TagType {
        switch self {
        case let .tagged(value): return value
        }
    }
}
