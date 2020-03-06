//
//  Coins.swift
//  SecuX
//
//  Created by Azules on 2019/1/27.
//  Copyright © 2019年 Azules. All rights reserved.
//

import Foundation
import UIKit

public enum CoinType : String{
    case BTC
    case BCH
    case BNB
    case DCT
    case DGB
    case DSH
    case ETH
    case GRS
    case LBR
    case LTC
    case XRP
    case IFC
}

public struct SecuXAccountHistory: Codable {
    public var address: String
    public var tx_type: String
    public var amount: Double
    public var amount_symbol: String?
    public var formatted_amount: Double
    public var amount_usd: Double
    public var timestamp: String
    public var detailsUrl: String
}

public struct SecuXAccountBalance: Codable {
    public var balance: Double
    public var formattedBalance: Double
    public var balance_usd: Double
}


open class SecuXAccount {

    public var name: String
    public var type: CoinType
    
    public var thePath: String
    public var theAddress: String
    public var theKey: String
    
    
    public init(name: String, type: CoinType, path: String, address: String, key: String) {

        self.name = name
        self.type = type
 
        self.thePath = ""
        self.theAddress = ""
        self.theKey = ""

    }
    
    
    func getCoinImg() -> UIImage?{
        switch self.type {
        case .BTC:
            return UIImage(named: "btc")
            
            
        case .BCH:
            return UIImage(named: "bch")
            
            
        case .BNB:
            return UIImage(named: "bnb")
            
            
        case .DCT, .IFC:
            return UIImage(named: "dct")
            
            
        case .DGB:
            return UIImage(named: "dgb")
            
            
        case .DSH:
            return UIImage(named: "dsh")
            
            
        case .ETH:
            return UIImage(named: "eth")
            
            
        case .GRS:
            return UIImage(named: "grs")
            
            
        case .LBR:
            return UIImage(named: "lbr")
            
            
        case .LTC:
            return UIImage(named: "ltc")
            
            
        case .XRP:
            return UIImage(named: "xrp")
            
        }
        
    }
}

