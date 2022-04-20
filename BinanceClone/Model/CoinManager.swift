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
        //       static let apiKey     = "3E12DAAE-C2F9-4E2D-83A2-21A645A44DC9"
        static let apiKey     = "9C500994-DBDB-4EF8-8168-7285BC29765F"
        
        static let newsURLString =  "https://newsdata.io/api/1/news?apikey=pub_601382047d277130103cfbd9b884b40c9104&language=en&q="
        
        static let coinString = "BTC;ETH;USDT;XRP;LUNA;ADA;DOT;DOGE;BUSD"
    }
    
    
    var delegate : CoinApiDelegate? = nil
    
    public var icons : [Icons] = []
    
    var whenReady : ((Result<[Crypto], Error>) -> Void)?
    
    
    //MARK: - Cryptos By Market Cap
    
    
    public func cryptosAssets(completion: @escaping (Result<[Cryptos], Error>) -> Void ) {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&price_change_percentage=1h") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Decoding the Response
                let cryptos = try JSONDecoder().decode([Cryptos].self, from: data)
                completion(.success(cryptos))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    public func searchCrypto(assetId: String, completion: @escaping (Result<[Cryptos], Error>) -> Void ) {
        

        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(assetId)&order=market_cap_desc&per_page=10&page=1&sparkline=false") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                // Decoding the Response
                let cryptos = try JSONDecoder().decode([Cryptos].self, from: data)
                completion(.success(cryptos))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    //MARK: - Trade View
    
    
    public func tradeAssets(assetId: String ,completion: @escaping (Result<[Crypto], Error>) -> Void ) {
        
        guard !icons.isEmpty else {
            whenReady = completion
            return
        }
        
        if assetId.isEmpty {
            
            guard let url = URL(string: Constants.coinApiURL + "assets?filter_asset_id=\(Constants.coinString)&apikey=" + Constants.apiKey) else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    // Decoding the Response
                    let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                    completion(.success(cryptos))
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
    
    
    //MARK: - Crypto Icons
    
    
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
                    self?.tradeAssets(assetId: "", completion: completion)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    //MARK: - Crypto Price Live against Currency
    
    
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
    
    //MARK: - Crypto News for particular Coin
    
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
                    completion(.success(article.results))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    //MARK: - Fetching Crypto Market Chart Points
    
    
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

