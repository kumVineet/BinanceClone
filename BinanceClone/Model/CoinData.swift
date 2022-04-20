//
//  CoinData.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 02/03/22.
//

import Foundation

struct Cryptos: Codable {
    
    let symbol: String
    let name : String
    let current_price : Double
    let image : String
    let high_24h: Double
    let low_24h: Double
    let price_change_percentage_1h_in_currency : Double?
    let price_change_percentage_24h : Double
    
}

struct Crypto: Codable {
    
    let asset_id : String
    let name : String?
    let type_is_crypto : Int
    let price_usd : Double?
    let id_icon : String?
}

struct Icons : Codable {
    let asset_id : String
    let url : String?
}

struct CurrencyPrice : Codable {
    
    let rate : Double
    let asset_id_quote : String
    let asset_id_base : String
}

struct GetNewsResponse: Codable {
    let results: [Article]
}

struct Article : Codable {
    let source_id : String
    let title: String
    let description: String?
    let link : String?
    let image_url  : String?
}

struct Price {
    let time: Double
    let high: Double
    init(list: [Double]) {
        
        self.time = list[0]
        self.high = list[1]
        
    }
}

struct ChartPoints: Decodable {
    let prices: [Price]
    enum CodingKeys: String, CodingKey {
        case prices
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.prices = try container.decode([[Double]].self, forKey: .prices).map(Price.init)
    }
}






