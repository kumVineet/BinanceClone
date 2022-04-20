//
//  MarketViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit
import FirebaseAuth


class MarketViewController: UIViewController {

    public var viewModels = [CoinModel.Cryptos]()
    
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var marketTableView: UITableView!
    
    
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
        

    }
    
    @IBAction func goToSearch(_ sender: UIBarButtonItem) {

        performSegue(withIdentifier: "searchPage", sender: self)
    }

    @IBAction func goToAccount(_ sender: UIBarButtonItem) {

        performSegue(withIdentifier: "accountPage", sender: self)
    }
    
    @IBAction func cryptoByMarketCap(_ sender: UIButton) {
        
        cryptoMarketCap()
    }
    
    @IBAction func allCryptos(_ sender: UIButton) {
        
        allCryptoMarket()
    }
    
    @IBAction func performingCryptos(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cryptoMarketCap()

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
                    self.marketTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func allCryptoMarket() {
 /*
        CoinAPI.shared.getIcons()

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
                    self?.marketTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cryptoDetail" {
            
        let detail = segue.destination as! CryptoDetailsViewController
        let selectedRow = marketTableView.indexPathForSelectedRow!.row
        
        detail.assetName = viewModels[selectedRow].name
        detail.assetSymbol = viewModels[selectedRow].symbol
        detail.iconData = viewModels[selectedRow].iconData
        detail.price = viewModels[selectedRow].current_price
        detail.hrChangePercent = viewModels[selectedRow].rateChange1h
        detail.dayChangePercent = viewModels[selectedRow].rateChange24h
        detail.dayHighPrice = viewModels[selectedRow].highPrice1D
            
        }else if segue.identifier == "searchPage" {
            
            if let controller = segue.destination as? SearchViewController {
            present(controller, animated: true, completion: nil)
                
            }
        }else if segue.identifier == "accountPage" {
            
            if let controller = segue.destination as? AccountViewController {
                present(controller, animated: true, completion: nil)
                
                }
        }
    }
    
    
}

//MARK: - TableView Delegate & DataSource

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = marketTableView.dequeueReusableCell(withIdentifier: "marketCell", for: indexPath) as! MarketTableViewCell

        cell.configure(with: viewModels[indexPath.row])
        
        self.removeSpinner()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "cryptoDetail", sender: self)
    }
}


