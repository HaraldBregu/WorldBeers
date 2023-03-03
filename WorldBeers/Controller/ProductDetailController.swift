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
    var drink: Drink!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = drink.name
        navigationItem.title = title
        
        firstBrewedLabel.text = "First Brewed".localized() + ": " + drink.firstBrewed
        firstBrewedLabel.isHidden = drink.firstBrewed.count == 0
        foodPairingLabel.text = "Food Pairing".localized() + ":\n" + "• " + drink.foodPairing.joined(separator: "\n• ")
        foodPairingLabel.isHidden = drink.foodPairing.count == 0
        brewersTipsLabel.text = "Brewers Tips".localized() + ":\n" + drink.brewersTips
        brewersTipsLabel.isHidden = drink.brewersTips.count == 0
        guard let url = URL(string: drink.imageUrl) else { return }
        productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_img"), context: nil)
    }
}
