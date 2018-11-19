//
//  Disposable.swift
//  Pods
//
//  Created by Sourav Chandra on 19/11/18.
//

import Foundation

typealias DisposeBlockType = () -> Void

public protocol DisposableType {
    func dispose()
    func disposed(by disposeBag: DisposeBag)
}

public class Disposable: DisposableType {

    private let disposeBlock: DisposeBlockType

    init( _ disposeBlock: @escaping DisposeBlockType) {
        self.disposeBlock = disposeBlock
    }

    public func dispose() {
        disposeBlock()
    }

    public func disposed(by disposeBag: DisposeBag) {
        disposeBag.addToDisposeBag(disposable: self)
    }
}
