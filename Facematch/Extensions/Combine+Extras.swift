//
//  Combine+Extras.swift
//  Facematch
//
//  Created by Gaston Mazzeo on 2/18/21.
//

#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    func flatMap<A: AnyObject, P: Publisher>(weak obj: A, transform: @escaping (A, Output) -> P) -> Publishers.FlatMap<P, Self> {
        flatMap { [weak obj] value in
            guard let obj = obj else {
                // swiftlint:disable:next force_cast
                return Empty<Output, Failure>() as! P
            }
            
            return transform(obj, value)
        }
    }

    func tryMap<A: AnyObject, T: Any>(weak obj: A, transform: @escaping (A, Output) throws -> T) -> Publishers.TryMap<Publishers.CompactMap<Self, (A, Self.Output)>, T> {
        compactMap { [weak obj] value in
            guard let obj = obj else {
                return nil
            }
            
            return (obj, value)
        }
        .tryMap { (obj, value) in
            try transform(obj, value)
        }
    }
    
    func handleOutput<A: AnyObject>(weak obj: A, selector: @escaping (A, Output) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { [weak obj] output in
            guard let obj = obj else {
                return
            }
            
            selector(obj, output)
        })
    }
}
#endif
