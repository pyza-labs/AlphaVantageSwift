//
//  URLSessionTask+extensions.swift
//  Pods
//
//  Created by Sourav Chandra on 19/11/18.
//

import Foundation

extension URLSessionTask: Callable {
    public func call() -> DisposableType {
        resume()
        return self
    }
}


extension URLSessionTask: DisposableType {
    
    public func disposed(by disposeBag: DisposeBag) {
        disposeBag.addToDisposeBag(disposable: self)
    }

    public func dispose() {
        cancel()
    }
}
