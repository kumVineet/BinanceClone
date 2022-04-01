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



