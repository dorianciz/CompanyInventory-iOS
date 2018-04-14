//
//  LoaderViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
    
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loaderIndicator.stopAnimating()
    }

}
