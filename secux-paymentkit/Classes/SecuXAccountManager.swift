//
//  SecuXAccountManager.swift
//  Pods-SecuXPaymentKit_Example
//
//  Created by Maochun Sun on 2020/1/22.
//

import Foundation

open class SecuXAccountManager{
    
    let secuXSvrReqHandler = SecuXServerRequestHandler()
    
    public init(){
        
    }
    
    public func registerUserAccount(userAccount: SecuXUserAccount) -> (SecuXRequestResult, Data?){
        logw("registerUserAccount")
        let (ret, data) = secuXSvrReqHandler.userRegister(account: userAccount.name, password: userAccount.password, email: userAccount.email, alias: userAccount.alias, phonenum: userAccount.phone)
        
        if ret == SecuXRequestResult.SecuXRequestOK, let data=data{
            
            guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String] else{
                return (SecuXRequestResult.SecuXRequestFailed, "Invalid json response from server".data(using: String.Encoding.utf8))
            }
            
            guard let coinType = responseJson["coinType"],
                let token = responseJson["symbol"],
                let balance = responseJson["balance"],
                let formattedBalance = responseJson["formattedBalance"],
                let usdBalance = responseJson["balance_usd"],
                let balDec = Decimal(string:balance),
                let formattedBalDec = Decimal(string: formattedBalance),
                let usdBalDec = Decimal(string: usdBalance) else{
                
                return (SecuXRequestResult.SecuXRequestFailed, "Invalid response from server".data(using: String.Encoding.utf8))
            }
            
            
            let tokenBalance = SecuXCoinTokenBalance(balance: balDec, formattedBalance: formattedBalDec, usdBalance: usdBalDec)
            
            var dict = [String:SecuXCoinTokenBalance]()
            dict["token"] = tokenBalance
            
            let _ = SecuXCoinAccount(type: coinType, name: token, tokenBalDict: dict)
            
            //userAccount.coinAccountArray = [SecuXCoinAccount]()
            //userAccount.coinAccountArray.append(coinAccount)
            
            
            return (ret, nil)
            
            
        }
        
        return (ret, nil)
    }
    
    public func loginUserAccount(userAccount:SecuXUserAccount) -> (SecuXRequestResult, Data?){
        logw("loginUserAccount")
        let (ret, data) = secuXSvrReqHandler.userLogin(account: userAccount.name, password: userAccount.password)
        if ret == SecuXRequestResult.SecuXRequestOK, let data = data{
           
            guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else{
                return (SecuXRequestResult.SecuXRequestFailed, "Invalid json response from server".data(using: String.Encoding.utf8))
            }
            
            guard let coinType = responseJson["coinType"] as? String,
                let token = responseJson["symbol"] as? String,
                let balance = responseJson["balance"]  as? Double,
                let formattedBalance = responseJson["formattedBalance"] as? Double,
                let usdBalance = responseJson["balance_usd"] as? Double else{
                
                
                return (SecuXRequestResult.SecuXRequestFailed, "Invalid response from server".data(using: String.Encoding.utf8))
            }
            
            
            let balDec = Decimal(balance)
            let formattedBalDec = Decimal(formattedBalance)
            let usdBalDec = Decimal(usdBalance)
            
            let tokenBalance = SecuXCoinTokenBalance(balance: balDec, formattedBalance: formattedBalDec, usdBalance: usdBalDec)
            
            var dict = [String:SecuXCoinTokenBalance]()
            dict["token"] = tokenBalance
            
            let coinAccount = SecuXCoinAccount(type: coinType, name: token, tokenBalDict: dict)
            
            userAccount.coinAccountArray = [SecuXCoinAccount]()
            userAccount.coinAccountArray.append(coinAccount)
            
            return (ret, nil)
            
        }
        
        return (ret, nil)
    }
    
    public func handleAccounTokenBalance(userAccount:SecuXUserAccount, json: [String:Any]) -> (SecuXRequestResult, Data?){
      
        logw("handleAccounTokenBalance")
        guard let coinType = json["coinType"] as? String,
             let token = json["symbol"] as? String,
             let accname = json["accountName"] as? String,
             let balance = json["balance"] as? Double,
             let formattedBalance = json["formattedBalance"] as? Double,
             let usdBalance = json["balance_usd"] as? Double else{
             
             return (SecuXRequestResult.SecuXRequestFailed, "Invalid response from server".data(using: String.Encoding.utf8))
        }
         
        logw("coinType=\(coinType) token=\(token) balance=\(balance)")
        
        let balDec = Decimal(balance)
        let formattedBalDec = Decimal(formattedBalance)
        let usdBalDec = Decimal(usdBalance)
        let tokenBalance = SecuXCoinTokenBalance(balance: balDec, formattedBalance: formattedBalDec, usdBalance: usdBalDec)
        
        let coinAccArr = userAccount.getCoinAccount(coinType: coinType)
        if coinAccArr.count > 0{
            for coinAcc in coinAccArr{
                if coinAcc.updateTokenBalance(token: token, tokenBal: tokenBalance){
                    coinAcc.accountName = accname;
                    break
                }
            }
        }else{
            var dict = [String : SecuXCoinTokenBalance]()
            dict[token] = tokenBalance
            let coinAcc = SecuXCoinAccount(type: coinType, name: accname, tokenBalDict: dict)
            userAccount.addCoinAccount(coinAcc: coinAcc)
            
        }
        return (SecuXRequestResult.SecuXRequestOK, nil)
    }
    
    public func getAccountBalance(userAccount:SecuXUserAccount, coinType: String? = nil, token: String? = nil) -> (SecuXRequestResult, Data?){
        logw("getAccountBalance")
        if let ctype = coinType, let token = token{
            let (ret, data) = secuXSvrReqHandler.getAccountBalance(coinType: ctype, token: token)
            
            if ret == SecuXRequestResult.SecuXRequestOK, let data = data{
                
                guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else{
                    return (SecuXRequestResult.SecuXRequestFailed, "Invalid json response from server".data(using: String.Encoding.utf8))
                }
                
                return handleAccounTokenBalance(userAccount: userAccount, json: responseJson)
            }
           
        }else{
            let (ret, data) = secuXSvrReqHandler.getAccountBalance();
            
            if ret == SecuXRequestResult.SecuXRequestOK, let data = data{
                
                guard let responseJsonArr = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else{
                    return (SecuXRequestResult.SecuXRequestFailed, "Invalid json response from server".data(using: String.Encoding.utf8))
                }
                
                for json in responseJsonArr{
                    let (result, errorData) = handleAccounTokenBalance(userAccount: userAccount, json: json)
                    if result != SecuXRequestResult.SecuXRequestOK{
                        return (result, errorData)
                    }
                }
                
                return (ret, nil)
                    
               
            }
        
            return (ret, data)
        }
        
        return (SecuXRequestResult.SecuXRequestFailed, nil)
    }
    
    
    public func doTransfer(coinType:String, token:String, feeSymbol:String,
                           amount:String, receiver:String) ->(SecuXRequestResult, Data?, SecuXTransferResult?){
        logw("doTransfer")
        let (ret, data) = secuXSvrReqHandler.doTransfer(coinType: coinType, token: token, feesymbol: feeSymbol, receiver: receiver, amount: amount)
        if ret == SecuXRequestResult.SecuXRequestOK, let data = data{
            guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else{
                return (SecuXRequestResult.SecuXRequestFailed, "Invalid json response from server".data(using: String.Encoding.utf8), nil)
            }
            
            guard let statusCode = responseJson["statusCode"] as? Int else{
                    return (SecuXRequestResult.SecuXRequestFailed, "Response has no statusCode".data(using:String.Encoding.utf8), nil)
            }
            
            if statusCode != 200{
                if let statusDesc = responseJson["statusDesc"] as? String{
                    return (SecuXRequestResult.SecuXRequestFailed, statusDesc.data(using: String.Encoding.utf8), nil)
                }else{
                    return (SecuXRequestResult.SecuXRequestFailed, "No error description".data(using: String.Encoding.utf8), nil)
                }
            }
            
            guard let txID = responseJson["txId"] as? String, let detailsUrl = responseJson["detailsUrl"] as? String else {
                return (SecuXRequestResult.SecuXRequestFailed, "Response has no txID/details URL".data(using:String.Encoding.utf8), nil)
            }
            
            
            let transRet = SecuXTransferResult()
            transRet.txID = txID
            transRet.detailsUrl = detailsUrl
            return (ret, nil, transRet)
        }
        
        return (ret, data, nil)
    }
    
    public func getTransferHistory(coinType:String, token:String, page:Int, count:Int)->(SecuXRequestResult, [SecuXTransferHistory]){
        logw("getTransferHistory")
        var historyArr = [SecuXTransferHistory]()
        let (ret, data) = secuXSvrReqHandler.getTransferHistory(cointType: coinType, token: token, page: page, pageItemCount: count)
        if ret == SecuXRequestResult.SecuXRequestOK, let data = data{
            
            guard let responseJsonArr = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else{
                return (SecuXRequestResult.SecuXRequestFailed, historyArr)
            }
            
            for json in responseJsonArr{
                let history = SecuXTransferHistory(hisJson: json)
                historyArr.append(history)
            }
        }
        
        return (ret, historyArr)
    }
}
