//
//  Set+Extras.swift
//  Facematch
//
//  Created by Jan Kaltoun on 04/07/2020.
//

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
