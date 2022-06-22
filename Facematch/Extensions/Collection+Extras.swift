//
//  Collection+Extras.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

extension Collection {
    func random(_ n: Int) -> ArraySlice<Element> {
        shuffled().prefix(n)
    }
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
