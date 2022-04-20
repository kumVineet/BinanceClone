//
//  SearchViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 25/02/22.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchDataBar: UISearchBar!
    @IBOutlet weak var viewOfTableView: UIView!
    
    public var viewModels = [CoinModel.Cryptos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showSpinner()
        

  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cryptoMarketCap()
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    public func cryptoMarketCap() {
        
        CoinAPI.shared.cryptosAssets { result in
            switch result {
            case .success(let models):
                
                self.viewModels = models.compactMap({ crypto in
                    
                    let price = crypto.current_price
                    let formatter = MarketViewController.numberFormat
                    let priceString = formatter.string(from: NSNumber(value: price))
                    
                    return CoinModel.Cryptos(symbol: crypto.symbol.uppercased(),
                                      name: crypto.name,
                                      current_price: priceString!,
                                      imageURL: URL(string: crypto.image)!,
                                      high_24: crypto.high_24h,
                                      low_24h: crypto.low_24h,
                                      price_change_1h: crypto.price_change_percentage_1h_in_currency ?? 1.00,
                                      price_change_24h: crypto.price_change_percentage_24h)
                })
                
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detail = segue.destination as! CryptoDetailsViewController
        let selectedRow = searchTableView.indexPathForSelectedRow!.row
        
        detail.assetName = viewModels[selectedRow].name
        detail.assetSymbol = viewModels[selectedRow].symbol
        detail.iconData = viewModels[selectedRow].iconData
        detail.price = viewModels[selectedRow].current_price
        detail.hrChangePercent = viewModels[selectedRow].rateChange1h
        detail.dayChangePercent = viewModels[selectedRow].rateChange24h
        detail.dayHighPrice = viewModels[selectedRow].highPrice1D
    }
    
}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        cell.configure(with: viewModels[indexPath.row])
        self.removeSpinner()
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "searchToDetail", sender: self)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }

        CoinAPI.shared.searchCrypto(assetId: text.lowercased()) { result in
            
            switch result {
            case .success(let models):
                
                self.viewModels = models.compactMap({ crypto in
                    
                    let price = crypto.current_price
                    let formatter = MarketViewController.numberFormat
                    let priceString = formatter.string(from: NSNumber(value: price))
                    
                    return CoinModel.Cryptos(symbol: crypto.symbol.uppercased(),
                                      name: crypto.name,
                                      current_price: priceString!,
                                      imageURL: URL(string: crypto.image)!,
                                      high_24: crypto.high_24h,
                                      low_24h: crypto.low_24h,
                                      price_change_1h: crypto.price_change_percentage_1h_in_currency ?? 1.00,
                                      price_change_24h: crypto.price_change_percentage_24h)
                })
                
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
 
    
    
}
