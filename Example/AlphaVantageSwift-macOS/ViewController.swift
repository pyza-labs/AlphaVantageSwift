//
//  ViewController.swift
//  AlphaVantageSwift-macOS
//
//  Created by Sourav Chandra on 13/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Cocoa
import Pods_AlphaVantageSwiftmacOS

class ViewController: NSViewController {

    let disposeBag = DisposeBag()

    @IBOutlet weak var label: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        AVProvider.setup(with: "6VLV5FWRPWYEA67Z")
        StockTimeSeries.intraday(interval: .five)
            .request(symbol: "MSFT") { [weak self] (response) in
                guard case let .success(value) = response.parsedResponse else { return }
                let stringValue = value.timeSeries.reduce("") {
                    return "\($0) \n \($1.key.timeIntervalSince1970) - \($1.value.open)"
                }
                DispatchQueue.main.async {
                    self?.label.stringValue = stringValue
                }
            }
            .call()
            .disposed(by: disposeBag)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

