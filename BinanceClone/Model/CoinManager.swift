//
//  CoinAPI.swift
//  BinanceClone
//
//  Created by Vineet Kumar on 02/03/22.
//

import Foundation
import UIKit
 
protocol CoinApiDelegate {
    func currencyPrice(_ coinManager : CoinAPI, coinPrice : CoinModel.CryptoToCurrency)
    func didFailWithError(error: Error)
}

 
class CoinAPI {
         
    static let shared = CoinAPI()
    
    struct Constants {
        
        static let coinApiURL = "https://rest.coinapi.io/v1/"
        static let apiKey     = "3E12DAAE-C2F9-4E2D-83A2-21A645A44DC9"
//        static let apiKey     = "9C500994-DBDB-4EF8-8168-7285BC29765F"
        
        static let newsURLString =  "https://newsdata.io/api/1/news?apikey=pub_601382047d277130103cfbd9b884b40c9104&language=en&q="
    }
    

    var delegate : CoinApiDelegate? = nil
         
    public var icons : [Icons] = []
    
    var whenReady : ((Result<[Crypto], Error>) -> Void)?
    
    //MARK: - Public
    

    public func cryptoAssets(assetId: String ,completion: @escaping (Result<[Crypto], Error>) -> Void ) {
        
        guard !icons.isEmpty else {
            whenReady = completion
            return
        }
        
        if assetId.isEmpty {
        
        guard let url = URL(string: Constants.coinApiURL + "assets?apikey=" + Constants.apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Decoding the Response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(
//                    cryptos.sorted { first, second in
//                    return first.price_usd ?? 0 > second.price_usd ?? 0
//                }
                    cryptos.filter({ crypto in
                        crypto.type_is_crypto == 1
                    })
                ))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
        }
        
        else {
            
            guard let url = URL(string: Constants.coinApiURL + "assets?filter_asset_id=\(assetId)&apikey=" + Constants.apiKey ) else {
                return
            }

            let task = URLSession.shared.dataTask(with: url) {  data, response, error in

                guard let data = data, error == nil else {
                    return
                }

                do {
                    // Decoding the Response
                    let searchCrypto = try JSONDecoder().decode([Crypto].self, from: data)
                    completion(.success(
                        searchCrypto.sorted { first, second in
                        return first.price_usd ?? 0 > second.price_usd ?? 0
                    }
                    ))
                }
                catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
 
         
    public func getIcons() {
        
        guard let url = URL(string: Constants.coinApiURL + "assets/icons/30?apikey=" + Constants.apiKey ) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Decoding the Response
                self?.icons = try JSONDecoder().decode([Icons].self, from: data)
                if let completion = self?.whenReady {
                    self?.cryptoAssets(assetId: "", completion: completion)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    public func getCoinPrice(for assetID: String, currency: String, delegate: CoinApiDelegate) {
        
        self.delegate = delegate
             guard let url = URL(string: Constants.coinApiURL + "exchangerate/\(assetID)/\(currency)?apikey=" + Constants.apiKey) else {
                 return
             }
             
             let task = URLSession.shared.dataTask(with: url) {  data, response, error in

                 guard let data = data, error == nil else {
                     self.delegate?.didFailWithError(error: error!)
                     return
                 }
                 do {
                     let cryptoPrice = try JSONDecoder().decode(CurrencyPrice.self, from: data)
                     let price = cryptoPrice.rate
                     let base = cryptoPrice.asset_id_base
                     let currency = cryptoPrice.asset_id_quote
                     let coinPrice = CoinModel.CryptoToCurrency(rate: price, asset_id_quote: currency, asset_id_base: base)
                     self.delegate?.currencyPrice(self, coinPrice: coinPrice)
                 }
                 catch {
                     self.delegate?.didFailWithError(error: error)
                 }
             }
             task.resume()
    }
    
    
    public func getNews(with assetID: String, completion: @escaping (Result<[Article], Error>) -> Void ) {
        
        guard let url = URL(string: Constants.newsURLString + assetID) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let article = try JSONDecoder().decode(GetNewsResponse.self, from: data)
                    print("Articles: \(article.results.count)")
                    completion(.success(article.results))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getChartPoints(with assetId: String, timeframe: Int, completion: @escaping (Result<[Price], Error>) -> Void) {
       
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(assetId)/market_chart?vs_currency=usd&days=\(timeframe)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let assetPoints = try JSONDecoder().decode(ChartPoints.self, from: data)
                    completion(.success(assetPoints.prices))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


/*
 class CoinApi {
    
    static let shared = CoinApi()
    
    
    /** BASE API URL **/
    fileprivate let coinApiURL = "https://rest.coinapi.io/v1/"
    /** Api-Key **/
    fileprivate let apiKey = "3E12DAAE-C2F9-4E2D-83A2-21A645A44DC9"
    
    var delegate : CoinManagerDelegate?
    
    public var icons : [CoinData.Icons] = []
    
    public func performRequest(assetId: String) {

        
        if assetId.isEmpty {
        
        guard let url = URL(string: coinApiURL + "assets?apikey=" + apiKey) else {
            return
        }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    print(safeData)
                    if let assets = self.assetsJSON(safeData) {
                        self.delegate?.cryptoAssets(self, assets: assets)
                    }
                }
            }
            task.resume()

    }
        else {
            
            guard let url = URL(string: coinApiURL + "assets?filter_asset_id=\(assetId)&apikey=" + apiKey ) else {
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let assets = self.assetsJSON(safeData) {
                        self.delegate?.cryptoAssets(self, assets: assets)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func assetsJSON (_ data : Data) -> CoinModel.CryptoAsset? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.Crypto.self, from: data)
            print(decodedData)
            let name = decodedData.name
            print(name!)
            let symbol = decodedData.asset_id
            let isCrypto = decodedData.type_is_crypto
            let price = decodedData.price_usd
            let iconUrl = URL(string: CoinApi.shared.icons.filter { icon in
                icon.asset_id == decodedData.asset_id
            }.first?.url ?? "")
            let assets = CoinModel.CryptoAsset(symbol: symbol, name: name, type_is_crypto: isCrypto, price: price, iconUrl: iconUrl)
            return assets
        } catch  {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    public func getIcons() {
        
        guard let url = URL(string: coinApiURL + "assets/icons/30?apikey=" + apiKey ) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let icons = self.iconsJSON(safeData) {
                    self.delegate?.cryptoIcons(self, icons: icons)
                }
            }
        }
        task.resume()
    }
    
    public func iconsJSON(_ data : Data) -> CoinModel.CryptoIcons? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.Icons.self, from: data)
            let symbol = decodedData.asset_id
            let imageUrl = decodedData.url
            let icons = CoinModel.CryptoIcons(asset_id: symbol, url: imageUrl)
            return icons
        } catch  {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
*/
