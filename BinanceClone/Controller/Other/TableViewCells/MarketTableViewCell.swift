//
//  MarketTableViewCell.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 25/02/22.
//

import UIKit

class MarketTableViewCellViewModel {
    
    let name: String
    let symbol: String
    let price : String
    let iconUrl: URL?
    let typeIsCrypto: Int
    var iconData : Data?
    
    init(name: String, symbol: String, price : String, iconUrl: URL?, typeIsCrypto: Int) {
        
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
        self.typeIsCrypto = typeIsCrypto
    }
}
 

class MarketTableViewCell: UITableViewCell {

    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var changePercent: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        changePercent.textColor = .green
        
        viewOfImage.backgroundColor = .yellow
        viewOfImage.layer.masksToBounds = true
        viewOfImage.layer.cornerRadius = viewOfImage.bounds.width / 2
        
        coinImageView.layer.masksToBounds = true
        coinImageView.layer.cornerRadius = coinImageView.bounds.width / 2
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coinImageView.image = UIImage(named: "diamond.png")
        shortLabel.text = nil
        longLabel.text = nil
        currentPrice.text = nil
    }
    
    func configure(with viewModel: MarketTableViewCellViewModel /*CoinModel.CryptoAsset*/) {
 
        longLabel.text = viewModel.name
        shortLabel.text = viewModel.symbol
        currentPrice.text = viewModel.price
        
        if let data = viewModel.iconData{
            coinImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if let data = data {
                    viewModel.iconData = data
                    DispatchQueue.main.async {
                        self?.coinImageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
        
        

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
