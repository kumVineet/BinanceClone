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
    
    private var viewModels = [MarketTableViewCellViewModel]()
//    public var viewModels = [CoinModel.CryptoAsset]()
    
    static let numberFormat : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.formatterBehavior = .default
        formatter.numberStyle = .currency
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showSpinner()
        
        
//        DispatchQueue.main.async {
//            self.searchTableView.reloadData()
//        }
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CoinAPI.shared.cryptoAssets(assetId: "") { [weak self] result in
            
            switch result {
            case .success(let models):

                self?.viewModels = models.compactMap({ crypto in

                    let price = crypto.price_usd ?? 0
                    let formatter = MarketViewController.numberFormat
                    let priceString = formatter.string(from: NSNumber(value: price))

                    let iconUrl = URL(string: CoinAPI.shared.icons.filter { icon in
                        icon.asset_id == crypto.asset_id
                    }.first?.url ?? "")

                    return MarketTableViewCellViewModel(name: crypto.name ?? " ",
                                                        symbol: crypto.asset_id ,
                                                        price: priceString ?? "$ 1.00",
                                                        iconUrl: iconUrl,
                                                        typeIsCrypto: crypto.type_is_crypto
                                                        )
                })
                
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "marketCell", for: indexPath) as! MarketTableViewCell
        
        cell.changePercent.text = "+34.60%"
        cell.configure(with: viewModels[indexPath.row])
        self.removeSpinner()
        
        return cell

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        CoinAPI.shared.cryptoAssets(assetId: text) { [weak self] result in
            
            
            switch result {
            case .success(let models):

                self?.viewModels = models.compactMap({ crypto in

                    let price = crypto.price_usd ?? 0
                    let formatter = MarketViewController.numberFormat
                    let priceString = formatter.string(from: NSNumber(value: price))

                    let iconUrl = URL(string: CoinAPI.shared.icons.filter { icon in
                        icon.asset_id == crypto.asset_id
                    }.first?.url ?? "")

                    return MarketTableViewCellViewModel(name: crypto.name ?? " ",
                                                        symbol: crypto.asset_id ,
                                                        price: priceString ?? "$ 1.00",
                                                        iconUrl: iconUrl,
                                                        typeIsCrypto: crypto.type_is_crypto
                                                        )
                })
                
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
 
    
    
}
