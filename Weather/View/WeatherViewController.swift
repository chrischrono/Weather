//
//  WeatherViewController.swift
//  Weather
//
//  Created by Christian on 21/04/19.
//  Copyright © 2019 Christian. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet private var latitudeTextField: UITextField!
    @IBOutlet private var longitudeTextField: UITextField!
    @IBOutlet private var forecastButton: UIButton!
    @IBOutlet private var forecastTextView: UITextView!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

