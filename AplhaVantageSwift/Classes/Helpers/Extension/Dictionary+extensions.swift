//
//  Dictionary+extensions.swift
//  Pods
//
//  Created by Sourav Chandra on 20/11/18.
//

import Foundation

extension Dictionary {
    func mapKeys<T>(_ block: (Key) -> T) -> [T: Value] {
        return reduce([:]) {
            var mutable = $0
            mutable[block($1.key)] = $1.value
            return mutable
        }
    }
}
