//
//  NewsTableViewCell.swift
//  BinanceClone
//
//  Created by Raksha. on 04/04/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitle.text = nil
        newsImage.image = UIImage(named: "news.png")
    }
    
    func configure(with viewModel: CoinModel.NewsModel) {
        
        newsTitle.text = viewModel.title
        newsDesc.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            newsImage.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL{
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.newsImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
