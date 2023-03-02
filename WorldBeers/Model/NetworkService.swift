// 
//  NetworkService.swift
//
//  Created by harald bregu on 02/03/23.
//  Copyright © 2019 MEGAGENERAL. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation


enum NetworkScheme: String {
    case HTTPS = "https"
}

enum NetworkMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

typealias ResponseClosure = (Result<Data, NetworkError>) -> Void

protocol NetworkingMethods {
    func get(path: String, query: [String: String])
}

enum NetworkError: Error {
    case invalidUrl
    case unableToComplete
    case invalidResponse
    case invalidData
}

class NetworkService: NetworkingMethods {
    static let shared = NetworkService()
    
    private init() {}
    
    var scheme: NetworkScheme = .HTTPS
    var host: String?
    var completed: ResponseClosure?
    
    func get(path: String, query: [String : String] = [:]) {
        
        guard let host = host, !host.isEmpty else {
            self.completed?(.failure(.invalidUrl))
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = query.map { URLQueryItem(name: $0, value: $1)}
        
        guard let url = urlComponents.url else {
            self.completed?(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkMethod.GET.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                self.completed?(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.completed?(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                self.completed?(.failure(.invalidData))
                return
            }
            
            self.completed?(.success(data))
            
        }.resume()
        
    }
}
