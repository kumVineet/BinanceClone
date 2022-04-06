//
//  MarketViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 22/02/22.
//

import UIKit
import FirebaseAuth


class MarketViewController: UIViewController {
    
    private var viewModels = [MarketTableViewCellViewModel]()
//    public var viewModels = [CoinModel.CryptoAsset]()
    
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
        
 //       CoinApi.shared.performRequest(assetId: "")
 

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
                    self?.marketTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detail = segue.destination as! CryptoDetailsViewController
        let selectedRow = marketTableView.indexPathForSelectedRow!.row
        
        detail.assetName = viewModels[selectedRow].name
        detail.iconData = viewModels[selectedRow].iconData
        detail.price = viewModels[selectedRow].price
    }
    
    @IBAction func onlyCrypto(_ sender: UIButton) {
        
        
    }
    
    @IBAction func hotAssets(_ sender: UIButton) {
        

    }
    
}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = marketTableView.dequeueReusableCell(withIdentifier: "marketCell", for: indexPath) as! MarketTableViewCell

            cell.changePercent.text = "+4.60%"
            cell.configure(with: viewModels[indexPath.row])
        
        self.removeSpinner()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "cryptoDetail", sender: self)
    }
}


