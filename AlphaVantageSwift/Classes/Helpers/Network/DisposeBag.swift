//
//  DisposeBag.swift
//  Pods
//
//  Created by Sourav Chandra on 19/11/18.
//

import Foundation

public class DisposeBag {
    private var disposables: [DisposableType] = []

    public init() {}

    func addToDisposeBag(disposable: DisposableType) {
        disposables.append(disposable)
    }

    deinit {
        disposables.forEach { $0.dispose() }
    }
}
