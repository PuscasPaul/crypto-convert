//
//  CoinManager.swift
//  CoinExchange
//
//  Created by Puscas Paul on 15.07.2023.
//

import Foundation

protocol CoinManagerDelegate {
    func lastPrice(_ bitcoinPrice: CoinManager, coin:CoinData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    private var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
          fatalError("Couldn't find file 'Secrets.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API-KEY") as? String else {
          fatalError("Couldn't find key 'API-KEY' in 'Secrets.plist'.")
        }
        return value
      }
    }
    
    let firstCurrencyArray = ["ETH", "SOL", "ADA", "EGLD", "BTC", "BNB","EUR", "USD", "GBP", "RON",  "XRP", "DOGE", "SHIB"]
    
    let secondCurrencyArray = ["EGLD","XRP", "BTC", "ETH", "SOL", "BNB", "DOGE", "SHIB", "EUR", "USD", "RON", "BRL","CAD","CNY","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RUB","SEK","SGD","USD","ZAR", "AUD"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(firstCurrency: String, secondCurrency: String) {
        let urlString = "\(baseURL)/\(firstCurrency)/\(secondCurrency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            // Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            // Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
//                let dataAsString = String(data: data!, encoding: .utf8)
//                print(dataAsString)
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        self.delegate?.lastPrice(self, coin: bitcoinPrice)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            // for Protocol and Delegate i have to add those 3 lines 👇🏻(or how manny they are in the CoinData)
            let lastPrice = decodedData.rate
            let secondCurrencySelected = decodedData.asset_id_quote
            let firstCurrencySelected = decodedData.asset_id_base
            // then i create a let and and use CoinData to save them and use them with return
            let cash = CoinData(rate: lastPrice, asset_id_base: firstCurrencySelected, asset_id_quote: secondCurrencySelected)
            return cash
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
