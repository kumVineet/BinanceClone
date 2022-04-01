//
//  TradeViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit

class TradeViewController: UIViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topCryptoTableView: UITableView!
    
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
        
        navigationItem.title = "Choose Crypto"
        
        self.showSpinner()

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
                     self?.topCryptoTableView.reloadData()
                 }
             case .failure(let error):
                 print(error)
             }
         }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let buy = segue.destination as! BuyViewController
        let selectedRow = topCryptoTableView.indexPathForSelectedRow!.row
        
        buy.assetID = viewModels[selectedRow].symbol
        buy.iconUrl = viewModels[selectedRow].iconData!
        buy.price = viewModels[selectedRow].price
    }

}

extension TradeViewController : UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = topCryptoTableView.dequeueReusableCell(withIdentifier: "topSearchCell", for: indexPath) as! TopSearchTableViewCell
        cell.configure(with: viewModels[indexPath.row])
        self.removeSpinner()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "buy", sender: self)
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
                    self?.topCryptoTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
