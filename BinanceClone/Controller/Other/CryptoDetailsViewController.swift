//
//  CryptoDetailsViewController.swift
//  BinanceClone
//
//  Created by Raksha. on 04/04/22.
//


import UIKit
import Charts
import SafariServices

class CryptoDetailsViewController: UIViewController {

    private var viewModels = [CoinModel.NewsModel]()
    private var chartModels = [CoinModel.ChartPoints]()
    private var lineChartEntry = [ChartDataEntry]()
    private var articles = [Article]()
    
    @IBOutlet weak var assetChartView: LineChartView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var assetPriceLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var assetName : String = ""
    var price : String = ""
    var iconData: Data? = nil
    var days: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.topItem!.title = assetName
        
        assetChartView.rightAxis.enabled = false
        assetChartView.leftAxis.enabled = false
        assetChartView.animate(xAxisDuration: 2.5)
        assetChartView.xAxis.enabled = false
        
        updateGraph()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        assetPriceLabel.text = price
        fetchNews()
        fetchChartPoints()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func daysChange(_ sender: UIButton) {
        
        if sender.tag == 1{
            days = 1
        }
        if sender.tag == 7{
            days = 7
        }
        if sender.tag == 30{
            days = 30
        }
        if sender.tag == 365{
            days = 365
        }
        
        fetchChartPoints()
        updateGraph()
        assetChartView.animate(xAxisDuration: 2.5)
    }

    
    private func fetchChartPoints() {
        
        CoinAPI.shared.getChartPoints(with: assetName.lowercased(), timeframe: days) { [weak self] result in
            
            switch result {
            case .success(let models):
                
                var chartPoints: [ChartDataEntry] = []
                for i in models {
                    let values = ChartDataEntry(x: i.time, y: i.high)
                    chartPoints.append(values)
                }
                self?.lineChartEntry = chartPoints
                DispatchQueue.main.async {
                    self?.updateGraph()
                }
                
            case .failure(let error):
                print(error)
            }
        }
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
    
    func updateGraph() {
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Price")
        line1.colors = [NSUIColor.yellow]
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        line1.lineWidth = 2.5

        let data = LineChartData(dataSet: line1)
        data.setDrawValues(false)
        assetChartView.data = data
        
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

extension CryptoDetailsViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        print(entry)
    }
}
