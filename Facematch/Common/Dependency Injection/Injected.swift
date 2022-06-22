//
//  Injected.swift
//  Facematch
//
//  Created by Jan Kaltoun on 20.08.2020.
//

@propertyWrapper
struct Injected<T> {
    let wrappedValue: T

    init() {
        wrappedValue = DIContainer.shared.resolve()
    }
}
