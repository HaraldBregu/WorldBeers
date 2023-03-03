// 
//  Beer.swift
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


struct Beer: Drink {
    var id: Int
    var name: String
    var imageUrl: String
    var description: String
    var abv: Double?
    var ibu: Double?
    var firstBrewed: String
    var foodPairing: [String]
    var brewersTips: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, imageUrl, description, abv, ibu, firstBrewed, foodPairing, brewersTips
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
      
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
        description = try values.decode(String.self, forKey: .description)
        abv = try values.decodeIfPresent(Double.self, forKey: .abv)
        ibu = try values.decodeIfPresent(Double.self, forKey: .ibu)
        firstBrewed = try values.decode(String.self, forKey: .firstBrewed)
        foodPairing = try values.decode([String].self, forKey: .foodPairing)
        brewersTips = try values.decode(String.self, forKey: .brewersTips)
    }
}
