# secux-paymentkit

[![CI Status](https://img.shields.io/travis/maochuns/secux-paymentkit.svg?style=flat)](https://travis-ci.org/maochuns/secux-paymentkit)
[![Version](https://img.shields.io/cocoapods/v/secux-paymentkit.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit)
[![License](https://img.shields.io/cocoapods/l/secux-paymentkit.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit)
[![Platform](https://img.shields.io/cocoapods/p/secux-paymentkit.svg?style=flat)](https://cocoapods.org/pods/secux-paymentkit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

### Installation

secux-paymentkit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
    pod 'secux-paymentkit'
```

### Add bluetooth privacy permissions in the plist

![Screenshot](Readme_PlistImg.png)

### Import the the module

```swift 
    import SecuXPaymentKit
```

## Usage


### SecuXAccount related operations

Use SecuXAccountManager object to do the operations below
```swift
    let accManager = SecuXAccountManager()
```

1. <b>Get supported coin/token</b>

#### <u>Declaration</u>
```swift
    func getSupportedCoinTokenArray() 
            -> (SecuXRequestResult, Data?, [(coin:String, token:String)]?)
```

#### <u>Return value</u>
        SecuXRequestResult shows the operation result, if the result is not SecuXRequestResult.SecuXRequestOK, data shall contains the error message. Otherwise, the returned array shall contain all the supported coin and token pairs.

#### <u>Sample</u>
```swift
    let (ret, data, coinTokenArray) = accManager.getSupportedCoinTokenArray()
    guard ret == SecuXRequestResult.SecuXRequestOK else{
        var error = ""
        if let data = data{
            error = String(data: data, encoding: .utf8) ?? ""
        }
        print("Error: \(error)")
        
        return
    }
    
    if let coinTokenArr = coinTokenArray{
        for item in coinTokenArr{
            print("coin=\(item.coin) token=\(item.token)")
        }
    }
```

2. <b>Registration</b>
#### <u>Declaration</u>
```swift
    func registerUserAccount(userAccount: SecuXUserAccount, 
                            coinType: String, 
                            token: String) -> (SecuXRequestResult, Data?)
```

#### <u>Parameters</u>
        userAccount: A SecuXUserAccount object with login name and password  
        coinType:    CoinType string  
        token:       Token string

#### <u>Return value</u>
        SecuXRequestResult shows the operation result. If the result is SecuXRequestOK, registration is successful, otherwise data might contain an error message.

#### <u>Sample</u>
```swift
    let usrAcc = SecuXUserAccount(email: name, password: pwd)
    var (ret, data) = accManager.registerUserAccount(userAccount: usrAcc, 
                                                     coinType: "DCT", 
                                                     token: "SPC")
    
    if ret == SecuXRequestResult.SecuXRequestOK{
        //Login the account
        ...
    }else{
        var errorMsg = ""
        if let data = data, let error = String(data: data, encoding: String.Encoding.utf8){
            errorMsg = error
        }
        print("Registration failed! error \(error)")
    }
```

3. <b>Login</b>
#### <u>Declaration</u>
```swift
    func loginUserAccount(userAccount:SecuXUserAccount) -> (SecuXRequestResult, Data?)
```
#### <u>Parameter</u>
        userAccount: A SecuXUserAccount object with login name and password  

#### <u>Return value</u>
        SecuXRequestResult shows the operation result. If the result is SecuXRequestOK, login is successful, otherwise data might contain an error message.

#### <u>Sample</u>
```swift
    let accManager = SecuXAccountManager()
    let usrAcc = SecuXUserAccount(email: name, password: pwd)
    
    var (ret, data) = accManager.loginUserAccount(userAccount: usrAcc)
    if ret == SecuXRequestResult.SecuXRequestOK{
        
        //Login successfully
        ...
        
    }else{
        var errorMsg = "Invalid email/password!"
        if let data = data, let error = String(data: data, encoding: String.Encoding.utf8){
            errorMsg = error
        }
        print("Login failed! error \(error)")
    }
```

4. <b>Get coin/token account list</b>
Must successfully login the server before calling the function

#### <u>Declaration</u>
```swift
    func getCoinAccountList(userAccount:SecuXUserAccount) -> (SecuXRequestResult, Data?)
```
#### <u>Parameter</u>
        userAccount: Successfully logined user account.

#### <u>Return value</u>
        SecuXRequestResult shows the operation result. If the result is SecuXRequestOK, getting coin/token account information is successful and coin/token account information is in the user account's coinAccountArray, otherwise data might contain an error message.

#### <u>Sample</u>
```swift
    let (ret, data) = accManager.getCoinAccountList(userAccount: usrAcc)
    if ret == SecuXRequestResult.SecuXRequestOK{    
        for coinAcc in theUserAccount!.coinAccountArray{
            let tokenArr = coinAcc.tokenBalanceDict.keys
            for token in tokenArr{
                print("coin/token account: \(coinAcc.coinType) \(token)")
            }
        }
    }else{
        var errorMsg = ""
        if let data = data, let error = String(data: data, encoding: String.Encoding.utf8){
            errorMsg = error
        }
        print("Get coin/token info. failed! error \(error)")
    }
```

5. <b>Get coin/token account balance</b> 

#### <u>Declaration</u>
```swift
    func getAccountBalance(userAccount:SecuXUserAccount, 
                           coinType: String? = nil, 
                           token: String? = nil) -> (SecuXRequestResult, Data?)
```
#### <u>Parameter</u>
        userAccount: A SecuXUserAccount object with login name and password  
        coinType:    CoinType string  
        token:       Token string

#### <u>Return value</u>
        SecuXRequestResult shows the operation result. If the result is SecuXRequestOK, getting coin/token account balance is successful and coin/token account balance can be found in the user account's coinAccountArray, otherwise data might contain an error message.

#### <u>Sample</u>
```swift
    let (ret, data) = accManager.getAccountBalance(userAccount: usrAcc, 
                                                   coinType: "DCT", token: "SPC")
                
    guard ret == SecuXRequestResult.SecuXRequestOK else{
        print("get \(coinAcc.coinType) \(token) balance failed")
        if let data = data{
            print("Error: \(String(data: data, encoding: String.Encoding.utf8) ?? "")")
        }
        continue
    }
    
    let coinAcc = usrAcc.getCoinAccount(coinType: "DCT")
    if let tokenBal = coinAcc.tokenBalanceDict["SPC"]{
        print("\(coinAcc.coinType) \(token) \(tokenBal.theBalance) \(tokenBal.theFormattedBalance) \(tokenBal.theUsdBalance)")
    }
```

### SecuXPayment related operations

Use SecuXPaymentManager object to do the operations below

    let paymentManager = SecuXPaymentManager()

1. <b>Parsing payment QRCode</b>
#### <u>Declaration</u>
#### <u>Parameter</u>
#### <u>Return value</u>
#### <u>Sample</u>

2. <b>Get store information</b>
#### <u>Declaration</u>
#### <u>Parameter</u>
#### <u>Return value</u>
#### <u>Sample</u>

3. <b>Do payment</b>
#### <u>Declaration</u>
#### <u>Parameter</u>
#### <u>Return value</u>
#### <u>Sample</u>


3. <b>Get payment history</b>
#### <u>Declaration</u>
#### <u>Parameter</u>
#### <u>Return value</u>
#### <u>Sample</u>

## Author

maochuns, maochunsun@secuxtech.com

## License

secux-paymentkit is available under the MIT license. See the LICENSE file for more info.
