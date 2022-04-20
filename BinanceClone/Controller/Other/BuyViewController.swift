//
//  BuySellViewController.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 16/03/22.
//

import UIKit

class BuyViewController: UIViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var assetPrice: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var iconUrl = Data()
    var assetID : String = "BTC"
    var price : String = ""
    var string : String = ""
    var desc : String = ""
    var total : Double = 0
    var coinAPI = CoinAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountView.layer.borderWidth = 3
        amountView.layer.borderColor = UIColor.yellow.cgColor
        amountView.layer.cornerRadius = 10
        
        viewOfImage.backgroundColor = .yellow
        viewOfImage.layer.masksToBounds = true
        viewOfImage.layer.cornerRadius = viewOfImage.bounds.width / 2
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        
        amount.text = string
        assetLabel.text = assetID
        imageView.image = UIImage(data: iconUrl)
        assetPrice.text = price

        
        coinAPI.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CoinAPI.shared.getCoinPrice(for: assetID, currency: "USD", delegate: self)
    }
    
    @IBAction func sellVC(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "sell", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func numpadInput(_ sender: UIButton) {
        
        if string.count <= 7 {
            
            if(sender.tag == 1) {
                string += "1"
            }
            if(sender.tag == 2) {
                string += "2"
            }
            if(sender.tag == 3) {
                string += "3"
            }
            if(sender.tag == 4) {
                string += "4"
            }
            if(sender.tag == 5) {
                string += "5"
            }
            if(sender.tag == 6) {
                string += "6"
            }
            if(sender.tag == 7) {
                string += "7"
            }
            if(sender.tag == 8) {
                string += "8"
            }
            if(sender.tag == 9) {
                string += "9"
            }
            if(sender.tag == 0) {
                string += "0"
            }
            if(sender.tag == 11) {
                let charset = CharacterSet(charactersIn: ".")
                if let _ = string.rangeOfCharacter(from: charset, options: .caseInsensitive) {
                    string += ""
                } else {
                    string += "."
                }
            }
        }
        amount.text = string
        totalAsset(inputAmount: Double(price)!, assetPrice: Double(string) ?? 0.0)
    }
    
    @IBAction func backSpace(_ sender: UIButton) {
        
        _ = string.popLast()
        amount.text = string
        totalAsset(inputAmount: Double(price)!, assetPrice: Double(string) ?? 0.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let sell = segue.destination as! SellViewController
        
        sell.assetID = assetID
        sell.iconUrl = iconUrl
        sell.price = price
        sell.string = string
    }
    
    func totalAsset(inputAmount: Double, assetPrice: Double) {
        
        total = assetPrice/inputAmount
        var number : String {
            return String(format: "%.5f", total)
        }
        desc = "Total \(assetID) : \(number)"
        descLabel.text = desc
    }
    
}

//MARK: - CoinApiDelegate

extension BuyViewController : CoinApiDelegate{
    
    func currencyPrice(_ coinManager: CoinAPI, coinPrice: CoinModel.CryptoToCurrency) {
        
        DispatchQueue.main.async{
            self.price = coinPrice.rateString
            self.assetPrice.text = self.price
            self.totalAsset(inputAmount: Double(self.price)!, assetPrice: Double(self.string) ?? 0.0)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension BuyViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCurrency = currencyArray[row]
        currencyLabel.text = selectedCurrency
        CoinAPI.shared.getCoinPrice(for: assetID, currency: selectedCurrency, delegate: self)
    }
    
}
