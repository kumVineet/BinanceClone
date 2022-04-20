//
//  CoinModel.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 16/03/22.
//

import Foundation

struct CoinModel {
    
    class Cryptos {

        let symbol: String
        let name : String
        let current_price : String
        let imageURL : URL?
        let high_24h: Double
        let low_24h: Double
        let price_change_1h : Double
        let price_change_24h : Double
        var iconData : Data?
        
        var rateChange1h: String {
            return String(format: "%.2f", price_change_1h)
        }
        var rateChange24h: String {
            return String(format: "%.2f", price_change_24h)
        }
        var highPrice1D: String {
            return String(format: "%.2f", high_24h)
        }
        
        init(symbol:String, name:String, current_price: String, imageURL: URL?, high_24: Double, low_24h: Double, price_change_1h : Double, price_change_24h : Double) {
            
            self.symbol = symbol
            self.name = name
            self.current_price = current_price
            self.imageURL = imageURL
            self.high_24h = high_24
            self.low_24h = low_24h
            self.price_change_1h = price_change_1h
            self.price_change_24h = price_change_24h

        }
    }
    
    struct CryptoToCurrency {
        
        let rate : Double
        let asset_id_quote : String
        let asset_id_base : String
        
        var rateString : String {
                return String(format: "%.3f", rate)
            }
    }
    
    struct NewsModel {
        
        let title: String
        let subtitle: String
        let imageURL: URL?
        var imageData: Data? = nil
    }
    
    struct ChartPoints {
        let time: Double
        let high: Double
    }

}

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
