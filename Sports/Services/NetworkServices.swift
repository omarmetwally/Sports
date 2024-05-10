//
//  NetworkServices.swift
//  Sports
//
//  Created by Omar on 10/05/2024.
//

import Foundation

import Foundation
import Alamofire

protocol NetworkProtocol {
    func fetchData<T: Decodable>(sport: Sport, endpoint: String, decodingType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void)
}

class NetworkServices: NetworkProtocol {
    func fetchData<T: Decodable>(sport: Sport, endpoint: String, decodingType: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(Constants.baseURL(for: sport))?met=\(endpoint)&APIkey=\(Constants.apiKey)"
        
        AF.request(urlString).validate().responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

