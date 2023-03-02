// 
//  NetworkManager.swift
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


/*
enum NetworkError: Error {
    case invalidUrl
    case unableToComplete
    case invalidResponse
    case invalidData
}

typealias ResponseClosure = (Result<[Beer], NetworkError>) -> Void

final class NetworkManager {
    static let shared = NetworkManager()
    static var scheme = "https"
    static var host = "api.punkapi.com"
    static var apiVersion = "v2"

    private init () {}
    
    
    func get() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = BeersNetwork.scheme
        urlComponents.host = BeersNetwork.host
        urlComponents.path = "/\(BeersNetwork.apiVersion)/\(path)"
            
       guard let url = urlComponents.url else {
           completed(.failure(.invalidUrl))
           return
       }
       
       let task = URLSession.shared.dataTask(with: url) { data, response, error in
           
           if let _ = error {
               completed(.failure(.unableToComplete))
               return
           }
           
           guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               completed(.failure(.invalidResponse))
               return
           }
       
           guard let data = data else {
               completed(.failure(.invalidData))
               return
           }
        
           do {
               let decoder = JSONDecoder()
               //decoder.keyDecodingStrategy = .convertFromSnakeCase
               let objects = try decoder.decode([Beer].self, from: data)
               completed(.success(objects))
           } catch {
               completed(.failure(.invalidData))
           }
       }
       task.resume()


    }
    
    func post() {
        
    }
    
    func put() {
        
    }
    
    func delete() {
        
    }

     func fetch(path: String, completed: @escaping ResponseClosure) {
         var urlComponents = URLComponents()
         urlComponents.scheme = BeersNetworkManager.scheme
         urlComponents.host = BeersNetworkManager.host
         urlComponents.path = "/\(BeersNetworkManager.apiVersion)/\(path)"
             
        guard let url = urlComponents.url else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
        
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
         
            do {
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase
                let objects = try decoder.decode([Beer].self, from: data)
                completed(.success(objects))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

}
 */
