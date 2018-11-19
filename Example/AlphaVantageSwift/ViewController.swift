//
//  ViewController.swift
//  AplhaVantageSwift
//
//  Created by Sourav Chandra on 11/12/2018.
//  Copyright (c) 2018 Sourav Chandra. All rights reserved.
//

import UIKit
import Pods_AplhaVantageSwiftiOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        AVProvider.setup(with: "")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

