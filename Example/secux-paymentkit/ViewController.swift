//
//  ViewController.swift
//  secux-paymentkit
//
//  Created by maochuns on 03/04/2020.
//  Copyright (c) 2020 maochuns. All rights reserved.
//

import UIKit
import secux_paymentkit

class ViewController: UIViewController {
    
    private let accountManager = SecuXAccountManager()
    private let paymentManager = SecuXPaymentManager()
    private var theUserAccount : SecuXUserAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.paymentManager.delegate = self
        DispatchQueue.global(qos: .default).async {
            self.doAccountActions()
            self.doPaymentActions()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Try account related functions
    func doAccountActions(){
        theUserAccount = SecuXUserAccount(email: "maochuntest7@secuxtech.com", phone: "0975123456", password: "12345678")
        
        //Login test
        var (ret, data) = accountManager.loginUserAccount(userAccount: theUserAccount!)
        guard ret == SecuXRequestResult.SecuXRequestOK else{
            print("login failed!")
            if let data = data{
                print("Error: \(String(data: data, encoding: String.Encoding.utf8) ?? "")")
            }
            return
        }
        
        //Get account balance
        (ret, data) = accountManager.getAccountBalance(userAccount: theUserAccount!)
        guard ret == SecuXRequestResult.SecuXRequestOK else{
            print("get balance failed!")
            if let data = data{
                print("Error: \(String(data: data, encoding: String.Encoding.utf8) ?? "")")
            }
            return
        }
        
        //Get balance for a specified coin and token account
        (ret, data) = accountManager.getAccountBalance(userAccount: theUserAccount!, coinType: "DCT", token: "SPC")
        
        //print out balance
        for coinAcc in theUserAccount!.coinAccountArray{
            let keyArr = coinAcc.tokenBalanceDict.keys
            for key in keyArr{
                if let tokenBal = coinAcc.tokenBalanceDict["key"]{
                    print("\(key) \(tokenBal.theBalance) \(tokenBal.theFormattedBalance) \(tokenBal.theUsdBalance)")
                }
                
            }
        }
        
        //Transfer
        let (reqret, reqdata, transRet) = accountManager.doTransfer(coinType: "DCT", token: "SPC", feeSymbol: "SFC", amount: "1.2", receiver: "maochuntest7@secuxtech.com")
        guard reqret == SecuXRequestResult.SecuXRequestOK else{
            print("transfer failed!")
            if let reqdata = reqdata{
                print("Error: \(String(data: reqdata, encoding: String.Encoding.utf8) ?? "")")
            }
            return
        }
        
        print("Transfer result txID=\(transRet?.txID ?? "") url=\(transRet?.detailsUrl ?? "")")
        
        //Tranfer history
        var pageIdx = 0
        let pageItemCount = 20
        while (true){
        
            let (ret, transHisArr) = accountManager.getTransferHistory(coinType: "DCT", token: "SPC", page: pageIdx, count: pageItemCount)
            
            if ret != SecuXRequestResult.SecuXRequestOK{
                print("get tranfer history failed \(ret)")
                break;
            }
            
            var idx = 0
            for tranHis in transHisArr{
                print("\(idx) \(tranHis.token) \(tranHis.timestamp) \(tranHis.formattedAmount) \(tranHis.detailsUrl)")
                idx += 1
            }
            
            if transHisArr.count < pageItemCount{
                break
            }
            
            pageIdx += 1
        }
        
    }
    
    //Try payment related functions
    func doPaymentActions(){
        
        //Get payment history
        print("get payment history")
        var pageIdx = 0
        let pageItemCount = 20
        while (true){
        
            let (ret, payHisArr) = paymentManager.getPaymentHistory(token: "", pageIdx: pageIdx, pageItemCount: pageItemCount)
            
            if ret != SecuXRequestResult.SecuXRequestOK{
                print("get payment history failed \(ret)")
                return
            }
            
            var idx = 0
            for payHis in payHisArr{
                print("\(idx) \(payHis.coinType) \(payHis.token) \(payHis.transactionTime) \(payHis.amount) \(payHis.detailsUrl)")
                idx += 1
            }
            
            if payHisArr.count < pageItemCount{
                break
            }
            
            pageIdx += 1
        }
        
        //Pay to store
        let paymentInfo = "{\"amount\":\"1.5\", \"coinType\":\"DCT\", \"token\":\"SPC\",\"deviceIDhash\":\"04793D374185C2167A420D250FFF93F05156350C\"}"
        let (ret, data) = paymentManager.getPaymentInfo(paymentInfo: paymentInfo)
        if ret == SecuXRequestResult.SecuXRequestOK, let data = data{
            print("get payment info. done")
            guard let responseJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else{
                print("Invalid json response from server")
                return
            }
            
            guard let devIDHash = responseJson["deviceIDhash"] as? String else{
                print("Response has no hashed devID")
                return
            }
            let (reqRet, storeInfo, img) = paymentManager.getStoreInfo(devID: devIDHash)
            if reqRet == SecuXRequestResult.SecuXRequestOK, storeInfo.count > 0, let _ = img, let payInfo = String(data:data, encoding: String.Encoding.utf8){
                print("get store info. done")
                paymentManager.doPaymentAsync(storeInfo: storeInfo, paymentInfo: payInfo)
            }else{
                print("get store info. failed")
            }
        }else{
            print("get payment info. from server failed")
        }
        
        
    }
    
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

}

//MARK: SecuXPaymentManagerDelegate implementation
extension ViewController: SecuXPaymentManagerDelegate{
    
    //Called when payment is completed. Returns payment result and error message.
    func paymentDone(ret: Bool, errorMsg: String) {
        print("paymentDone \(ret) \(errorMsg)")
        
        if ret{
            showMessage(title: "Payment success!", message: "")
        }else{
            showMessage(title: "Payment fail!", message:errorMsg)
        }
    }
    
    //Called when payment status is changed. Payment status are: "Device connecting...", "DCT transferring..." and "Device verifying..."
    func updatePaymentStatus(status: String) {
        print("updatePaymentStatus \(status)")
    }
    
}

