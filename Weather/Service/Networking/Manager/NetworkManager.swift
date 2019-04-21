//
//  NetworkManager.swift
//  NetworkLayer
//
//

import Foundation


protocol DarkskyAPINetworkProtocol {
    init(environment: NetworkEnvironment)
    /**
     Get weather forecast's data of a location based on DarkskyAPI
     - Parameter latitude: latitude coordinate of the location
     - Parameter longitude: longitudde coordinate of the location
     - Parameter completion: block to handle the Forecast results
     */
    func getForecast(latitude: Double, longitude: Double, completion: @escaping (_ forecastResponse: ForecastResponse?,_ error: String?)->())
    
}

class DarkskyAPINetworkManager: DarkskyAPINetworkProtocol {
    static var environment : NetworkEnvironment = .production
    let router = Router<DarkskyAPI>()
    
    required init(environment: NetworkEnvironment) {
        DarkskyAPINetworkManager.environment = environment
    }
    
    
    /**
     Get weather forecast's data of a location based on DarkskyAPI
     - Parameter latitude: latitude coordinate of the location
     - Parameter longitude: longitudde coordinate of the location
     - Parameter completion: block to handle the Forecast results
     */
    func getForecast(latitude: Double, longitude: Double, completion: @escaping (_ forecastResponse: ForecastResponse?,_ error: String?)->()) {
        router.request(.getForecast(latitude: latitude, longitude: longitude)) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                /*let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(jsonData)*/
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecastResponse, nil)
            }catch {
                print(error)
                completion(nil, NetworkResponse.unableToDecode.rawValue)
            }
        }
    }
}
