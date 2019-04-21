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
    
    var weatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
        initViewModel()
    }

    @IBAction func forecastButtonDidTapped(sender: UIButton) {
        weatherViewModel.userRequestForecast(latitude: latitudeTextField.text ?? "", longitude: longitudeTextField.text ?? "")
    }
    
    @IBAction func bgButtonDidTapped(sender: UIButton) {
        latitudeTextField.resignFirstResponder()
        longitudeTextField.resignFirstResponder()
    }

}

//MARK:- viewModel related
extension WeatherViewController {
    private func initViewModel() {
        weatherViewModel.reloadForecastDataClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadForecastData()
            }
        }
        
        weatherViewModel.showLoadingViewClosure = { [weak self] (isLoading) in
            DispatchQueue.main.async {
                self?.showLoadingView(isLoading)
            }
        }
        
        weatherViewModel.updateStatusViewClosure = { [weak self] (status) in
            DispatchQueue.main.async {
                self?.updateStatusView(status)
            }
        }
        
        weatherViewModel.startWeatherForecasting()
    }
}

//MARK:- view related
extension WeatherViewController {
    private func initView() {
        forecastButton.layer.cornerRadius = 8
        forecastTextView.text = ""
        statusLabel.text = nil
    }
    
    private func reloadForecastData() {
        latitudeTextField.text = String(weatherViewModel.latitude)
        longitudeTextField.text = String(weatherViewModel.longitude)
        
        let forecast = weatherViewModel.forecast
        var details = ""
        
        for field in ForecastFields.allCases {
            let key = field.rawValue
            if let value = forecast[key] {
                details += "\n\(key): \(value)"
            }
        }
        
        forecastTextView.text = details
    }
    
    private func showLoadingView(_ isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
    
    private func updateStatusView(_ status: String?) {
        var statusText: String? = nil
        if let status = status {
            statusText = status.localized()
        }
        statusLabel.text = statusText
    }
}
