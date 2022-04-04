//
//  CryptoDetailsViewController.swift
//  BinanceClone
//
//  Created by Raksha. on 04/04/22.
//

import UIKit
import SafariServices

class CryptoDetailsViewController: UIViewController {

    private var viewModels = [CoinModel.NewsModel]()
    private var articles = [Article]()
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var assetPriceLabel: UILabel!
    @IBOutlet weak var graphImage: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var assetName : String = ""
    var price : String = ""
    var iconData: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.topItem!.title = assetName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        assetPriceLabel.text = price
        graphImage.image = UIImage(data: iconData! )
        fetchNews()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func fetchNews() {
        CoinAPI.shared.getNews(with: assetName) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    CoinModel.NewsModel(title: $0.title,
                                        subtitle: $0.description ?? "No Description",
                                        imageURL: URL(string: $0.image_url ?? ""))
                })
                DispatchQueue.main.async {
                    
                    self?.newsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension CryptoDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated: true)
        let article = articles[indexPath.row]

        guard let url = URL(string: article.link ?? "" ) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
}
