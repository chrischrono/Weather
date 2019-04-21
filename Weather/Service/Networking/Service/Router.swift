//
//  Router.swift
//  NetworkLayer
//
//

import Foundation

public enum NetworkResponse:String {
    case success
    case authenticationError = "network_authentication_error"
    case badRequest = "network_bad_request"
    case outdated = "network_outdated"
    case failed = "network_failed"
    case noData = "network_no_data"
    case unableToDecode = "network_unable_to_decode"
    case noResponseObject = "network_no_response_object"
    case noNetworkConnection = "no_network_connection"
}

public enum Result<String>{
    case success
    case failure(String)
}

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: String?)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
    func handleNetworkResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<String>
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private let session = URLSession(configuration: .default)
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        //let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let self = self else {
                    return
                }
                let result = self.handleNetworkResponse(data: data, response: response, error: error)
                switch result{
                case .success:
                    completion(data, response, nil)
                case .failure(let error):
                    completion(data, response, error)
                }
            })
        }catch {
            completion(nil, nil, error.localizedDescription)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    
    /**
     Handle all basic network error responses
     */
    func handleNetworkResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<String>{
        if error != nil {
            return .failure(NetworkResponse.noNetworkConnection.rawValue)
        }
        
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...299:
                print("HTTPURLResponse: success")
            case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
            case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
            case 600: return .failure(NetworkResponse.outdated.rawValue)
            default: return .failure(NetworkResponse.failed.rawValue)
            }
        }
        
        guard data != nil else {
            return .failure(NetworkResponse.noData.rawValue)
        }
        
        return .success
    }
}

