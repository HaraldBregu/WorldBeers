// 
//  BeerService.swift
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


typealias ResponseBeerClosure = (Result<[Beer], NetworkError>) -> Void

class BeerService: NetworkingMethods {
    static let shared = BeerService()
    
    var networkService: NetworkService?
    
    private init() {
        
    }
    
    var completed: ResponseBeerClosure?
    
    func get(path: String, query: [String: String] = [:]) {
        
        guard let service = networkService else {
            self.completed?(.failure(.invalidUrl))
            return
        }
        
        service.get(path: path, query: query)
        
        service.completed = { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let objects = try decoder.decode([Beer].self, from: data)
                    self.completed?(.success(objects))
                } catch {
                    self.completed?(.failure(.invalidData))
                }
                break
            case .failure(let error):
                self.completed?(.failure(error))
                break
            }
        }
    }
}
