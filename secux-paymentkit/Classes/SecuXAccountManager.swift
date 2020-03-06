//
//  SecuXAccountManager.swift
//  Pods-SecuXPaymentKit_Example
//
//  Created by Maochun Sun on 2020/1/22.
//

import Foundation

open class SecuXAccountManager{
    
    let secXSvrReqHandler = SecuXServerRequestHandler()
    
    public init(){
        
    }
    
    open func getAccountBalance(account: SecuXAccount) -> (Bool, SecuXAccountBalance?){
        
        switch account.type{
            
        case .DCT, .IFC:
            return self.getDCTAccountBalance(account: account)
            
        
        default:
            break
        }
        
        return (false, nil)
    }
    
    
    open func getAccountHistory(account: SecuXAccount) -> (Bool, [SecuXAccountHistory]){
        
        switch account.type{

        case .DCT, .IFC:
            return self.getDCTAccountHistory(account: account)
            
        default:
            break
        }
        
        return (false, [])
    }
    
    
    open func getCoinUSDRate() -> [CoinType: Double]{
        
        var rateDict: [CoinType: Double] = [:]
        
        let (ret, data) = self.secXSvrReqHandler.getCoinCurrency()
        if ret, let data = data{
            do{
                let jsonArr  = try JSONSerialization.jsonObject(with: data, options: []) as! [[String : String]]
                //print(jsonArr)
                
                for json in jsonArr{
                    
                    if let type = json["coinType"], let coinType = CoinType(rawValue: type),
                        let rate = json["usdPrice"], let coinRate = Double(rate){
                        
                        rateDict[coinType] = coinRate
                    }

                }

            }catch{
                logw("updateCoinCurrencyAction error: " + error.localizedDescription)
            }
        }else{
            logw("updateCoinCurrencyAction failed")
        }
        
        return rateDict
    }
    
    
    private func getDCTAccountBalance(account: SecuXAccount) -> (Bool, SecuXAccountBalance?){
        logw("getDCTAccountBalance \(account.name)")
        
        if account.name.count == 0{
           return (false, nil)
        }
        
        let param = ["coinType": account.type.rawValue, "pubKey":"\(account.name)"]
        let (ret, data) = self.secXSvrReqHandler.getAccountBalance(param: param)
        if ret, let balInfo = data{
        
            return self.handleAccountBalanceData(account: account, accInfo: balInfo)
            
        }else{
            logw("getDCTAccountBalance \(account.name) failed")
        }
        
        return (false, nil)
    }
    
    private func getDCTAccountHistory(account: SecuXAccount) -> (Bool, [SecuXAccountHistory]){
        logw("getDCTAccountHistory \(account.name)")
        if account.name.count == 0{
           return (false, [])
        }

        let param = ["coinType": "DCT", "pubKey":"\(account.name)"]
        let (ret, data) = self.secXSvrReqHandler.getAccountHistory(param: param)
        if ret, let accInfo = data{
        
            return self.handleAccountHistoryData(account: account, accInfo: accInfo)
        }else{
            logw("getDCTAccountHistory \(account.name) failed")
        }
        return (false, [])
    }
    

    
    private func handleAccountBalanceData(account: SecuXAccount, accInfo: Data) -> (Bool, SecuXAccountBalance?){
        
        let decoder = JSONDecoder()
        do{
            
            let balance = try decoder.decode(SecuXAccountBalance.self, from: accInfo)
            return (true, balance)
            
            
        }catch{
            logw("handleAccountBalanceData error: " + error.localizedDescription)
        }
        
        return (false, nil)
    }
    
    private func handleAccountHistoryData(account: SecuXAccount, accInfo: Data) -> (Bool, [SecuXAccountHistory]){
        let decoder = JSONDecoder()
   
        do {
            
            let accHistory = try decoder.decode([SecuXAccountHistory].self, from: accInfo)
            return (true, accHistory)
            
            
            
        } catch let e {
            logw("handleAccountHistoryData error: " + e.localizedDescription)
        }
        
        
        return (false, [])
    }
}
