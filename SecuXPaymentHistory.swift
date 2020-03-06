//
//  SecuXPaymentHistory.swift
//  secux-paymentkit
//
//  Created by Maochun Sun on 2020/3/6.
//

import Foundation

public class SecuXPaymentHistory{
    
    var theID : Int = 0
    
    var storeID : Int = 0
    var storeName : String = ""
    
    var userAccountName : String = ""
    var transactionCode : String = ""
    var transactionType : String = ""
    
    var payPlatorm : String = ""
    var payChannel : String = ""
    
    var coinType : String = ""
    var token : String = ""
    var amount : String = ""
    
    var transactionStatus : String = ""
    var transactionTime : String = ""
    
    var remark : String = ""
    var detailsUrl : String = ""
    
    init() {
        
    }
    
    init?(hisData: Data) {
        do {
            if let hisJson = try JSONSerialization.jsonObject(with: hisData, options: []) as? [String: Any]{
                
                self.theID = hisJson["id"] as! Int
                self.storeID = hisJson["storeID"] as! Int
                self.storeName = hisJson["storeName"] as! String
                self.userAccountName = hisJson["account"] as! String
                self.transactionCode = hisJson["transactionCode"] as! String
                self.transactionType = hisJson["transactionType"] as! String
                self.payPlatorm = hisJson["payPlatform"] as! String
                self.payChannel = hisJson["payChannel"] as! String
                self.coinType = hisJson["coinType"] as! String
                self.token = hisJson["symbol"] as! String
                self.amount = hisJson["amount"] as! String
                self.transactionStatus = hisJson["transactionStatus"] as! String
                self.transactionTime = hisJson["transactionTime"] as! String
                self.remark = hisJson["remark"] as! String
                self.detailsUrl = hisJson["detailsUrl"] as! String
            }else{
                return nil
            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    init?(hisJson: [String : Any]) {
        
        guard let id = hisJson["id"] as? Int,
            let storeID = hisJson["storeID"] as? Int,
            let storeName = hisJson["storeName"] as? String,
            let userAccountName = hisJson["account"] as? String,
            let transactionCode = hisJson["transactionCode"] as? String,
            let transactionType = hisJson["transactionType"] as? String,
            let payPlatorm = hisJson["payPlatform"] as? String,
            let payChannel = hisJson["payChannel"] as? String,
            let coinType = hisJson["coinType"] as? String,
            let token = hisJson["symbol"] as? String,
            let amount = hisJson["amount"] as? String,
            let transactionStatus = hisJson["transactionStatus"] as? String,
            let transactionTime = hisJson["transactionTime"] as? String,
            let remark = hisJson["remark"] as? String,
            let detailsUrl = hisJson["detailsUrl"] as? String else{
                return nil
        }
        
        self.theID = id
        self.storeID = storeID
        self.storeName = storeName
        self.userAccountName = userAccountName
        self.transactionCode = transactionCode
        self.transactionType = transactionType
        self.payPlatorm = payPlatorm
        self.payChannel = payChannel
        self.coinType = coinType
        self.token = token
        self.amount = amount
        self.transactionStatus = transactionStatus
        self.transactionTime = transactionTime
        self.remark = remark
        self.detailsUrl = detailsUrl
        
    }
    
}
