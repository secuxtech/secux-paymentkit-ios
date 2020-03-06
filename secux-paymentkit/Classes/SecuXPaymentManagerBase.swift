//
//  PaymentHandler.swift
//  SecuXPaymentKit
//
//  Created by Maochun Sun on 2020/1/16.
//  Copyright © 2020 SecuX. All rights reserved.
//

import Foundation
import SPManager

import CoreNFC


open class SecuXPaymentManagerBase{
    
    let secXSvrReqHandler = SecuXServerRequestHandler()
    let paymentPeripheralManager = PaymentPeripheralManager.init()
    
    open var delegate: SecuXPaymentManagerDelegate?

    
    
    private func sendInfoToDevice(paymentInfo: PaymentInfo){
        
        logw("AccountPaymentViewModel sendInfoToDevice")
        
        let (ret, data) = self.secXSvrReqHandler.doPayment(payInfo: paymentInfo)
        if ret==SecuXRequestResult.SecuXRequestOK, let payInfo = data {
            
            do{
                let json  = try JSONSerialization.jsonObject(with: payInfo, options: []) as! [String : Any]
                print("sendInfoToDevice recv \(json)  \n--------")
                
                if let statusCode = json["statusCode"] as? Int, let statusDesc = json["statusDesc"] as? String{
                    if statusCode != 200{
                        self.handlePaymentDone(ret: false, errorMsg: statusDesc)
                        return
                    }
                }
                
                if let machineControlParams = json["machineControlParam"] as? [String : Any],
                    let encryptedStr = json["encryptedTransaction"] as? String {
                    
                    let encrypted = Data(base64Encoded: encryptedStr)
                    
                    logw("AccountPaymentViewModel doPaymentVerification")
                   
                    self.handlePaymentStatus(status: "Device verifying ...")
                    
                    
                    self.paymentPeripheralManager.doPaymentVerification(encrypted, machineControlParams: machineControlParams){ (result, error) in
                     
                        logw("AccountPaymentViewModel doPaymentVerification done")
                        if (error != nil) {
                         
                            var msgStr:String = "\(String(describing: error))"
                            if let responseCode = result?["responseCode"] as? NSData {
                                msgStr += " ,responeCode:\(responseCode)"
                            }
                            
                            self.handlePaymentDone(ret: false, errorMsg: msgStr)
                            
                            
                            return

                        }else{
                            print("payment verification done!")
                            
                            self.handlePaymentDone(ret: true, errorMsg: "")
                            
                            
                            return
                        }
                        
                    }

                    
                }else{
                    
                    self.handlePaymentDone(ret: false, errorMsg: "Invalid payment data from server")
                    
                }
                
            }catch{
                print("doPayment error: " + error.localizedDescription)
                self.handlePaymentDone(ret: false, errorMsg: error.localizedDescription)
                
                return
            }
            
           
        }else if ret==SecuXRequestResult.SecuXRequestNoToken || ret==SecuXRequestResult.SecuXRequestUnauthorized{
            
            self.handlePaymentDone(ret: false, errorMsg: "no token")
            
        }else{
            
            print("doPayment failed!!")
            self.handlePaymentDone(ret: false, errorMsg: "Send request to server failed.")
            
        }
        
    }
    
    private func handleDeviceAuthenicationResult(paymentInfo: PaymentInfo, ivKey: String?, error: Error?){
        if error != nil || ivKey == nil || ivKey?.count == 0 { // there is an error from SDK
            print("error: \(String(describing: error))")
            
            if let theError = error{
                let code = (theError as NSError).code
                if code == 25 || ivKey == nil || ivKey?.count == 0{
                     self.handlePaymentDone(ret: false, errorMsg: "No payment device")
                     return
                 }
                 //self.showMessage(title: "Error", message: msg)
                
                self.handlePaymentDone(ret: false, errorMsg: theError.localizedDescription)
            }else{
                self.handlePaymentDone(ret: false, errorMsg: "Device authentiation failed")
            }
            
           
        }else{  // get ivKey for data encryption
            self.paymentPeripheralManager.doGetIvKey { result, error in
                
               logw("AccountPaymentViewModel doGetIvKey done")
               
               
                if ((error) != nil) {
                   logw("error: \(String(describing: error))")
                   self.handlePaymentDone(ret: false, errorMsg: String(describing: error))
                   
                }else if let ivKey = result, ivKey.count > 0{
                    logw("ivKey: \(String(describing: ivKey))")
                    
                    self.handlePaymentStatus(status: "\(paymentInfo.token) transferring...")
                    
                   //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                       
                    DispatchQueue.global(qos: .default).async{
                    
                        let paymentInfoWithIVkey = paymentInfo
                        paymentInfoWithIVkey.ivKey = ivKey
                        self.sendInfoToDevice(paymentInfo: paymentInfoWithIVkey)
                   
                   }
                   

                }else{
                   self.handlePaymentDone(ret: false, errorMsg: "No ivkey")
               }
            }
        }
    }
    
    internal func doPayment(paymentInfo: PaymentInfo, devConfigInfo: PaymentDevConfigInfo) {
        
        logw("doPayment \(paymentInfo.amount) \(paymentInfo.deviceID) \(devConfigInfo.connTimeout)")
        
        self.handlePaymentStatus(status: "Device connecting...")
        
        paymentPeripheralManager.discoverNearbyPeripherals(Double(devConfigInfo.scanTimeout),
                                                           checkRSSI: Int32(devConfigInfo.rssi)) { result, error in
                     
            logw("result was \(String(describing: result)), and error was \(String(describing: error))")
                                                    
            if let error = error{
                self.handlePaymentDone(ret: false, errorMsg: error.localizedDescription)
                return
            }
                
            if result?.count == 0{
                self.handlePaymentDone(ret: false, errorMsg: "No payment device")
                return
            }

    
            self.paymentPeripheralManager.doPeripheralAuthenticityVerification(Double(devConfigInfo.scanTimeout),
                                                                               connectDeviceId: paymentInfo.deviceID,
                                                                               checkRSSI: Int32(devConfigInfo.rssi),
                                                                               connectionTimeout: Double(devConfigInfo.connTimeout)) { result, error in
    
                //logw("AccountPaymentViewModel doPeripheralAuthenticityVerification done \(result ?? "")")
                self.handleDeviceAuthenicationResult(paymentInfo: paymentInfo, ivKey: result, error: error)
            
            }
            
        }
    }
 
    
    internal func handlePaymentDone(ret: Bool, errorMsg: String){
        DispatchQueue.main.async {
            self.delegate?.paymentDone(ret: ret, errorMsg: errorMsg)
        }
    }
    
    internal func handlePaymentStatus(status: String){
        DispatchQueue.main.async {
            self.delegate?.updatePaymentStatus(status: status)
        }
    }
    

}
