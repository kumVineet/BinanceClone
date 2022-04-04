//
//  CoinData.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 02/03/22.
//

import Foundation

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



//struct CoinData {
//
//    struct Crypto: Codable {
//
//        let asset_id : String
//        let name : String?
//        let type_is_crypto : Int
//        let price_usd : Double?
//        let id_icon : String?
//
//    }
//
//    struct Icons : Codable {
//        let asset_id : String
//        let url : String?
//    }
//}



