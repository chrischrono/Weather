//
//  DarkskyAPIEndPoint.swift
//  NetworkLayer
//
// source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation


public enum DarkskyAPI {
    case getForecast(latitude: Double, longitude: Double)
}

extension DarkskyAPI: EndPointType {
    
    /** API base urls. */
    var environmentBaseURL : String {
        switch DarkskyAPINetworkManager.environment {
        case .production:
            return "https://api.darksky.net/"
        default:
            return "https://api.darksky.net/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    /** API path for specific request. */
    var path: String {
        switch self {
        //https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/latitude,longitude
        case .getForecast(let latitude, let longitude):
            return "forecast/2bb07c3bece89caf533ac9a5d23d8417/\(latitude),\(longitude)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    /** generate task based on requested DarkskyAPI. */
    var task: HTTPTask {
        switch self {
        case .getForecast:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}



