//
//  CoinData.swift
//  CoinExchange
//
//  Created by Puscas Paul on 15.07.2023.
//

import Foundation

struct CoinData: Decodable {
    let rate: Double
    let asset_id_base: String
    let asset_id_quote: String
    
}
