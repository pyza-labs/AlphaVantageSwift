//
//  Callable.swift
//  Pods
//
//  Created by Sourav Chandra on 19/11/18.
//

import Foundation

public protocol Callable {
    func call() -> DisposableType
}
