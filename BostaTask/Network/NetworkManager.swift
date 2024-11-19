//
//  NetworkManager.swift
//  BostaTask
//
//  Created by Marco on 2024-11-18.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    static func request(request: URLRequest) ->  AnyPublisher<Data, any Error>
}

class NetworkManager: NetworkManagerProtocol{
    
    enum NetworkingErrors: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url):
                return "[🔥] Bad response from URL: \(url)"
            case .unknown:
                return "[⚠️] Unknown error occured."
            }
        }
    }
    
    static func request(request: URLRequest) ->  AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw NetworkingErrors.badURLResponse(url: request.url!)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
