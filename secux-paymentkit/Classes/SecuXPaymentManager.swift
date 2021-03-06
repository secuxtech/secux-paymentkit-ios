//
//  SecuXPaymentManager.swift
//  SecuXPaymentKit
//
//  Created by Maochun Sun on 2020/1/16.
//  Copyright © 2020 SecuX. All rights reserved.
//

import Foundation
import CoreNFC
import SPManager



class PaymentInfo {
    var coinType: String = ""
    var token: String = ""
    var amount: String = ""
    var deviceID: String = ""
    var ivKey: String = ""
    
    init?(infoStr: String) {
        logw("init PaymentInfo from " ) //+ infoStr)
        if let data = infoStr.data(using: .utf8) {
            do {
                if let infoJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?],
                   let coinType = infoJson["coinType"] as? String, let token = infoJson["token"] as? String,
                   let devID = infoJson["deviceID"] as? String, let amount = infoJson["amount"] as? String{
                    
                    self.coinType = coinType
                    self.token = token
                    self.deviceID = devID
                    self.amount = amount
                    
                }else{
                    return nil
                }
                
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        
    }
}

class PaymentDevConfigInfo{
    var storeCode = ""
    var storeName = ""
    var devID = ""
    var scanTimeout : Int = 5
    var connTimeout : Int = 30
    var rssi : Int = -80
    
    init?(storeInfo: String) {
        logw("init PaymentDevConfigInfo from " + storeInfo)
        if let data = storeInfo.data(using: .utf8) {
            do {
                if let infoJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?],
                   let code = infoJson["storeCode"] as? String, let name = infoJson["name"] as? String,
                    let devID = infoJson["deviceId"] as? String, let sto = infoJson["scanTimeout"] as? Int,
                    let cto = infoJson["connectionTimeout"] as? Int, let rssi = infoJson["checkRSSI"] as? Int{
                    
                    self.storeCode = code
                    self.storeName = name
                    self.devID = devID
                    self.scanTimeout = sto
                    self.connTimeout = cto
                    self.rssi = rssi
                    
                }else{
                    return nil
                }
                
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
    }
}

public protocol SecuXPaymentManagerDelegate{
    func paymentDone(ret: Bool, transactionCode:String, errorMsg: String)
    func updatePaymentStatus(status: String)
}

open class SecuXPaymentManager: SecuXPaymentManagerBase {
    
    public override init() {
        super.init()
    }
    
    open func getStoreInfo(devID:String) -> (SecuXRequestResult, String, UIImage?, [(coin:String, token:String)]?){
        
        let (ret, data) = self.secXSvrReqHandler.getStoreInfo(devID: devID)
        if ret == SecuXRequestResult.SecuXRequestOK, let storeInfo = data{
            do{
                let json  = try JSONSerialization.jsonObject(with: storeInfo, options: []) as! [String : Any]
                
                guard let imgStr = json["icon"] as? String else{
                    logw("getStoreInfo no icon  \(json)")
                    return (SecuXRequestResult.SecuXRequestFailed, "Response has no icon info.", nil, nil)
                }
                
            
                guard let url = URL(string: imgStr),let data = try? Data(contentsOf: url),let image = UIImage(data: data) else{
                    logw("generate store logo img failed!")
                    return (SecuXRequestResult.SecuXRequestFailed, "generate store logo img failed", nil, nil)
                }
                
                var coinTokenArray = [(coin:String, token:String)]()
                if let supportedCoinTokenArray = json["supportedSymbol"] as? [[String]]{
                    for item in supportedCoinTokenArray{
                        
                        if item.count == 2{
                            coinTokenArray.append((item[0], item[1]))
                        }else{
                            logw("Invalid supported symbol from server")
                        }
                    }
                }
                
                return (ret, String(data: storeInfo, encoding: String.Encoding.utf8) ?? "", image, coinTokenArray)
                
            }catch{
                logw("getAccountInfo error: " + error.localizedDescription)
                return (SecuXRequestResult.SecuXRequestFailed, "Response json invalid", nil, nil)
            }
            
        }
            
        return (ret, "", nil, nil)
        
    }
    
    open func getPaymentInfo(paymentInfo: String)->(SecuXRequestResult, Data?){
       
        let (ret, data) = self.secXSvrReqHandler.getDeviceInfo(paymentInfo: paymentInfo)
        return (ret, data)
        
    }
    
    open func getPaymentHistory(token:String, pageIdx:Int, pageItemCount: Int)->(SecuXRequestResult, [SecuXPaymentHistory]){
        var historyArray = [SecuXPaymentHistory]()
        
        let (ret, data) = self.secXSvrReqHandler.getPaymentHistory(token: token, pageIdx: pageIdx, pageItemCount: pageItemCount)
        if ret==SecuXRequestResult.SecuXRequestOK, let hisData = data {
            do{
                let jsonArr  = try JSONSerialization.jsonObject(with: hisData, options: []) as! [[String : Any]]
                for hisJson in jsonArr{
                    if let paymentHis = SecuXPaymentHistory.init(hisJson: hisJson){
                        historyArray.append(paymentHis)
                    }else{
                        logw("Invalid payment history item")
                    }
                }
                
                return (ret, historyArray)
                
            }catch{
                logw("getAccountInfo error: " + error.localizedDescription)
                return (SecuXRequestResult.SecuXRequestFailed, historyArray)
            }
        }
        
        return (ret, historyArray)
    }
    
    open func getPaymentHistory(token:String, transactionCode:String)->(SecuXRequestResult, SecuXPaymentHistory?){
        
        let (ret, data) = self.secXSvrReqHandler.getPaymentHistory(token: token, transactionCode: transactionCode)
        if ret==SecuXRequestResult.SecuXRequestOK, let hisData = data {
            do{
                let jsonArr  = try JSONSerialization.jsonObject(with: hisData, options: []) as! [[String : Any]]
                for hisJson in jsonArr{
                    if let paymentHis = SecuXPaymentHistory.init(hisJson: hisJson){
                        return (ret, paymentHis)
                    }else{
                        logw("Invalid payment history item")
                    }
                }
                
            }catch{
                logw("getAccountInfo error: " + error.localizedDescription)
                return (SecuXRequestResult.SecuXRequestFailed, nil)
            }
        }
        
        return (ret, nil)
    }

    open func doPaymentAsync(storeInfo: String, paymentInfo: String){
        
        DispatchQueue.global(qos: .default).async {
            
            guard let payInfo = PaymentInfo.init(infoStr: paymentInfo) else{
                self.handlePaymentDone(ret: false, errorMsg: "Invalid payment info.")
                return
            }
            
            guard let payDevConfigInfo = PaymentDevConfigInfo.init(storeInfo: storeInfo) else{
                self.handlePaymentDone(ret: false, errorMsg: "Invalid store info.")
                return
            }
            
            
            self.doPayment(paymentInfo: payInfo, devConfigInfo: payDevConfigInfo)
        }
    }

}
