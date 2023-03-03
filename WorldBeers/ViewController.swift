//
//  ViewController.swift
//
//  Created by harald bregu on 01/03/23.
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
import MBProgressHUD


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    lazy var resultSearchController = UISearchController()
    lazy var viewModel = ProductViewModel()
    
    
    var currentPage: Int = 1
    
    var beers: [Beer] = [] {
        didSet {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    var filteredBeers: [Beer] {
        guard let searchText = resultSearchController.searchBar.text, searchText.count > 0 else {
            return self.beers
        }
        
        return beers.filter {
            $0.name.range(of: searchText, options: [.caseInsensitive]) != nil ||
            $0.description.range(of: searchText, options: [.caseInsensitive]) != nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WorldBeers".localized()
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.searchBar.placeholder = "Cerca un prodotto"
        resultSearchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = resultSearchController

        getAllProducts()
    }
    
    @objc func refresh() {
        getAllProducts()
    }
    
}



extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel, indexPath: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.beers.count-1 && !resultSearchController.isActive {
            currentPage += 1
            getAllProducts()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "productDetailController") as? ProductDetailController else { return }
        let beer = viewModel.beers[indexPath.row]
        controller.beer = beer
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterBeers(text: searchController.searchBar.text)
        tableView.reloadData()
    }
    
}

extension ViewController {
    
    private func getAllProducts() {
        
        showIndicator(withTitle: "Fetching products")
        
        let networkService = NetworkService.shared
        networkService.scheme = .HTTPS
        networkService.host = "api.punkapi.com"

        let beerService = BeerService.shared
        beerService.networkService = networkService
        beerService.get(path: "/v2/beers", query: [
            "page": String(currentPage),
            "per_page" : "5"
        ])
        beerService.completed = { [unowned self] result in
            switch result {
            case .success(let data):
                viewModel.saveBeers(beers: data)
                print(data.count)
                break
            case .failure(let error):
                print(error)
                break
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                self.hideIndicator()
            })
        }
    }
    
    func showIndicator(withTitle title: String) {
       let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.isUserInteractionEnabled = false
        indicator.show(animated: true)
    }

    func hideIndicator() {
       MBProgressHUD.hide(for: self.view, animated: true)
    }
}
