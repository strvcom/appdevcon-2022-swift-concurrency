//
//  Array+Extras.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/8/21.
//

extension Array {
    subscript(safe range: Range<Index>) -> ArraySlice<Element> {
        let initial = Swift.min(range.startIndex, self.endIndex)
        let final = Swift.min(range.endIndex, self.endIndex)
        return self[initial..<final]
    }
}
