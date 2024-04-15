//
//  NetworkManager.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import Foundation
import Alamofire

enum NetworkError: String, Error {
    case dataError = "Response returned with no data to decode."
    case decodeError = "Failed to correctly recognize or process the received data."
    case serverResponseError = "No server response to URL request."
    case statusCodeError = "Unknown response code status."
    case clientError = "You need to be authenticated first."
    case serverError = "The request cannot be processed due to a server error"
    case internetConnectionError = "The Internet connection appears to be offline."
}

protocol NetworkProtocol {
    static var shared: NetworkProtocol { get set }
    func fetchData(endpoint: String, method: HTTPMethod, completion: @escaping (Result<Articles, Error>) -> Void)
}

class NetworkManager: NetworkProtocol {
    static var shared: NetworkProtocol = NetworkManager()
    private let reachabilityManager = NetworkReachabilityManager()
    private let baseURL = "https://newsapi.org"
    private let apiKey = "&apiKey=977e4b83946b42a1aba422dc52cefbb1"
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Methods
    func fetchData(endpoint: String, method: HTTPMethod, completion: @escaping NetworkCompletionHandler) {
        reachabilityManager?.startListening { reachabilityStatus in
            guard reachabilityStatus != .notReachable else {
                return completion(.failure(NetworkError.internetConnectionError)) }
            
            let url = self.baseURL + endpoint + self.apiKey
            AF.request(url, method: method).response { dataResponse in
                switch dataResponse.result {
                case .success(let optionalData):
                    let unspecifiedResult = self.decode(optionalData)
                    completion(unspecifiedResult)
                case .failure(let error):
                    let errorResult = self.handleNetwork(dataResponse.response, with: error)
                    completion(errorResult)
                }
            }
        }
    }
    
    private func decode(_ optionalData: Data?) -> Result<Articles, Error> {
        guard let unwrappedData = optionalData else {
            return .failure(NetworkError.dataError) }
        do {
            let decodedData = try JSONDecoder().decode(Articles.self, from: unwrappedData)
            return .success(decodedData)
        } catch {
            return .failure(NetworkError.decodeError)
        }
    }
    
    private func handleNetwork(_ response: HTTPURLResponse?,
                               with error: AFError) -> Result<Articles, Error> {
        guard let statusCode = response?.statusCode else {
            return .failure(NetworkError.serverResponseError) }
        switch statusCode {
        case 300...399:
            return .failure(NetworkError.statusCodeError)
        case 400...499:
            return .failure(NetworkError.clientError)
        case 500...599:
            return .failure(NetworkError.serverError)
        default:
            return .failure(error)
        }
    }
}
