//
//  CryptoDetailsViewController.swift
//  BinanceClone
//
//  Created by Raksha. on 04/04/22.
//


import UIKit
import Charts
import SafariServices

class CryptoDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    private var viewModels = [CoinModel.NewsModel]()
    private var lineChartEntry = [ChartDataEntry]()
    private var articles = [Article]()
    
    @IBOutlet weak var assetChartView: LineChartView!
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var assetPriceLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hrChange: UILabel!
    @IBOutlet weak var dayChange: UILabel!
    @IBOutlet weak var dayHigh: UILabel!
    @IBOutlet weak var assetSymbolLabel: UILabel!
    @IBOutlet weak var assetCostLabel: UILabel!
    
    var assetName : String = ""
    var assetSymbol : String = ""
    var price : String = ""
    var iconData: Data? = nil
    var days: Int = 1
    var flag : Bool = false
    var hrChangePercent: String = ""
    var dayChangePercent: String = ""
    var dayHighPrice: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem!.title = assetName
        
        assetChartView.rightAxis.enabled = false
        assetChartView.leftAxis.enabled = false
        assetChartView.animate(xAxisDuration: 2.5)
        assetChartView.xAxis.enabled = false
        dayHigh.textColor = .green
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width: contentWidth, height:contentHeight )
        scrollView.delegate = self
        newsTableView.delegate = self
        scrollView.bounces = false
        newsTableView.bounces = false
        newsTableView.isScrollEnabled = false
        
        updateGraph()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        assetPriceLabel.text = price
        hrChange.text = hrChangePercent + "%"
        dayChange.text = dayChangePercent + "%"
        dayHigh.text = "$" + dayHighPrice
        assetSymbolLabel.text = "1 " + assetSymbol
        assetCostLabel.text = "≈ " + price
        
        
        if checkPercent(value: hrChange.text!) {
            hrChange.textColor = .red
        }else {
            hrChange.textColor = .green
        }
        
        if checkPercent(value: dayChange.text!) {
            dayChange.textColor = .red
        }else {
            dayChange.textColor = .green
        }
        
        
        fetchNews()
        fetchChartPoints()
    }
    
    public func checkPercent(value: String) -> Bool {
        
        let charset = CharacterSet(charactersIn: "-")
        if let _ = value.rangeOfCharacter(from: charset, options: .caseInsensitive) {
            return true
        } else {
            return false
        }
    }
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyCrypto(_ sender: UIButton) {
        
        performSegue(withIdentifier: "buyFromDetail", sender: self)
    }
    
    @IBAction func daysChange(_ sender: UIButton) {
        
        if sender.tag == 1 && sender.tag == 0{
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
        //        if flag {
        //            line1.colors = [NSUIColor.green]
        //        }else {
        //            line1.colors = [NSUIColor.red]
        //        }
        line1.colors = [NSUIColor.green]
        line1.drawCirclesEnabled = false
        line1.mode = .cubicBezier
        line1.lineWidth = 2.5
        
        let data = LineChartData(dataSet: line1)
        data.setDrawValues(false)
        assetChartView.data = data
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let buy = segue.destination as! BuyViewController
        
        buy.assetID = assetSymbol
        buy.iconUrl = iconData!
        buy.price = price
    }
    

    
}

//MARK: - Extensions

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

//MARK: - Chart View

extension CryptoDetailsViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        print(entry)
    }
}
