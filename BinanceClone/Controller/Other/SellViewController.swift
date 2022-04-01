//
//  SellViewController.swift
//  BinanceClone
//
//  Created by Raksha. on 30/03/22.
//

import UIKit

class SellViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var assetPrice: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var iconUrl = Data()
    var assetID : String = "BTC"
    var price   : String = ""
    var string : String = ""
    
    var coinAPI = CoinAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    
    @IBAction func sellCrypto(_ sender: UIButton) {
    }
    
    @IBAction func numpadInput(_ sender: UIButton) {
        
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
        amount.text = string
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        
        let delete = string.popLast()
         amount.text = string
         print(delete!)
    }
    
    @IBAction func goToBuy(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}

//MARK: - CoinApiDelegate

extension SellViewController : CoinApiDelegate{
    
    func currencyPrice(_ coinManager: CoinAPI, coinPrice: CoinModel.CryptoToCurrency) {

        print("++>>===>>>", coinPrice.rate)
        DispatchQueue.main.async{

            self.assetPrice.text = coinPrice.rateString
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension SellViewController : UIPickerViewDataSource, UIPickerViewDelegate {

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
