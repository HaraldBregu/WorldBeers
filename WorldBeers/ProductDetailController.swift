// 
//  ProductDetailController.swift
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

import UIKit

class ProductDetailController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var firstBrewedLabel: UILabel!
    @IBOutlet weak var foodPairingLabel: UILabel!
    @IBOutlet weak var brewersTipsLabel: UILabel!
    
    var beer: Beer!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = beer.name
        navigationItem.title = title
        
        firstBrewedLabel.text = beer.firstBrewed
        firstBrewedLabel.isHidden = beer.firstBrewed.count == 0
        foodPairingLabel.text = "• " + beer.foodPairing.joined(separator: "\n• ")
        foodPairingLabel.isHidden = beer.foodPairing.count == 0
        brewersTipsLabel.text = beer.brewersTips
        brewersTipsLabel.isHidden = beer.brewersTips.count == 0
        
        productImageView.image = UIImage()
        if let url = URL(string: beer.imageUrl) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print("Download Finished")
                // always update the UI from the main thread
                
                DispatchQueue.main.async() { [unowned self] in
                    self.productImageView.image = UIImage(data: data)
                }
            }
        }
        

    }
 
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
