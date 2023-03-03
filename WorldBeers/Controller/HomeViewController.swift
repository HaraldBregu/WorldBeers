//
//  HomeViewController.swift
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


class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    lazy var resultSearchController = UISearchController()
    lazy var viewModel = ProductViewModel()
    var currentPage: Int = 1
    
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
        resultSearchController.searchBar.placeholder = "Search a product".localized()
        resultSearchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = resultSearchController
        
        fetchAllDrinks()
    }
    
    @objc func refresh() {
        fetchAllDrinks()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        return cell.configure(with: viewModel, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.drinks.count-1 && !resultSearchController.isActive {
            currentPage += 1
            fetchAllDrinks()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "productDetailController") as? ProductDetailController else { return }
        let drink = viewModel.drinks[indexPath.row]
        controller.drink = drink
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterDrinks(text: searchController.searchBar.text)
        tableView.reloadData()
    }
}

extension HomeViewController {
    
    private func fetchAllDrinks() {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = "Fetching products".localized()
        indicator.isUserInteractionEnabled = false
        indicator.show(animated: true)
        
        BeerService.shared
            .get(page: currentPage)
            .completed = { [unowned self] result in
               
                switch result {
                case .success(let data):
                    viewModel.saveDrinks(data)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                    MBProgressHUD.hide(for: self.view, animated: true)
                })
            }
    }
}
