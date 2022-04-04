//
//  CoinModel.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 16/03/22.
//

import Foundation

struct CoinModel {
    
    struct CryptoAsset  {
        
        let symbol : String
        let name : String?
        let type_is_crypto : Int
        let price : Double?
        let iconUrl : URL?
        
    }

    struct CryptoIcons  {
        let asset_id : String
        let url : String?
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
}


