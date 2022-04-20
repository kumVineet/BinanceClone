//
//  SearchTableViewCell.swift
//  BinanceClone
//
//  Created by Raksha. on 08/04/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var shortLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var percentChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
    }
    
    func checkPercent(value: String) -> Bool {
        
        let charset = CharacterSet(charactersIn: "-")
        if let _ = value.rangeOfCharacter(from: charset, options: .caseInsensitive) {
            return true
        } else {
            return false
        }
    }
    
    func configure(with viewModel: CoinModel.Cryptos ) {
        
        longLabel.text = viewModel.name
        shortLabel.text = viewModel.symbol
        currentPrice.text = viewModel.current_price
        percentChange.text = viewModel.rateChange1h
        
        if checkPercent(value: viewModel.rateChange1h) {
            percentChange.textColor = .red
        }else {
            percentChange.textColor = .green
        }
        
        // Image
        if let data  = viewModel.iconData{
            coinImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                
                if let data = data {
                    viewModel.iconData = data
                    DispatchQueue.main.async {
                        self.coinImageView.image = UIImage(data: data)
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
