//
//  TopSearchTableViewCell.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 14/03/22.
//

import UIKit

class TopSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var longName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewOfImage.backgroundColor = .yellow
        viewOfImage.layer.masksToBounds = true
        viewOfImage.layer.cornerRadius = viewOfImage.bounds.width / 2
        
        coinImageView.layer.masksToBounds = true
        coinImageView.layer.cornerRadius = coinImageView.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coinImageView.image = UIImage(named: "diamond.png")
        shortName.text = nil
        longName.text = nil
    }

    func configure(with viewModel: MarketTableViewCellViewModel /*CoinModel.CryptoAsset*/) {
        
        longName.text = viewModel.name
        shortName.text = viewModel.symbol
        
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
    
}
