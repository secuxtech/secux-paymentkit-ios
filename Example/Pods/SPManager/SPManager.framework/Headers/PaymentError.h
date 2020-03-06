//
//  PaymentError.h
//  PaymentPeripheralManagerSDK
//
//  Created by SecuX Technology Inc. on 2019/09/13.
//  Copyright © 2019 年 SecuX Technology Inc. All rights reserved.
//

#ifndef PaymentError_h
#define PaymentError_h

// MARK: - Error Codes -
enum BleCharacteristicErrorCode: int {
    readTimeout = 1,
    writeTimeout = 2,
    notSerializable = 3,
    readNotSupported = 4,
    writeNotSupported = 5,
    notifyNotSupported = 6,
    commandFailure = 7,
    commandTimeout = 8
};

enum BlePeripheralErrorCode: int {
    serviceDiscoveryTimeout = 20,
    disconnected = 21,
    noServices = 23,
    serviceDiscoveryInProgress = 24,
    connectTimeout = 25
};

enum BlePeripheralManagerErrorCode: int {
    isAdvertising = 40,
    isNotAdvertising = 41,
    addServiceFailed = 42,
    restoreFailed = 43
};

enum BleCentralErrorCode: int {
    isScanning = 50,
    isPoweredOff = 51,
    peripheralScanTimeout = 53,
    peripheralRssiInvalid = 54,
    isDisconnected = 55
};

enum BleServiceErrorCode: int {
    characteristicDiscoveryTimeout = 60,
    characteristicDiscoveryInProgress = 61,
    notExistingCharacteristic = 62
};

enum SDKErrorCode: int {
    unactivatedDeviceErr = 71
};

enum paramterErrorCode: int {
    missingTicketId = 80,
    missingAmount = 81,
    missingParameter = 82,
    wrongParameterLength = 83
};


enum commandErrorCode: int {
    wrongIvKey = 90,
    noIvKey = 91,
    activationResponseErr = 92,
    alreadyActivationReposeErr = 93,
    eTicketResponseErr = 94,
    paymentResponseErr = 95,
    paymentResponseErr01 = 96,
    paymentResponseErr02 = 97,
    paymentResponseErr03 = 98,
    paymentResponseErr04 = 99,
    paymentResponseErr05 = 991,
    paymentResponseErr06 = 992,
    paymentResponseErr07 = 993,
    paymentResponseErr08 = 994,
    paymentResponseErr09 = 995,
    enableOtaError = 996,
    cleanLogError = 997
};

enum commandType: int {
    activatePeripheral = 100,
    reActivatePeripheral = 101,
    validatePeripheral = 102,
    payMoney = 103,
    enableOTA = 104,
    cleanLog = 105
};


//// MARK: - Errors -
#define PAYMENT_DOMAIN @"com.secuX.pay"

// MARK: Characteristic
#define characteristicReadTimeout [NSError errorWithDomain:PAYMENT_DOMAIN code:readTimeout userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic read timeout", NSLocalizedDescriptionKey, nil]]
#define characteristicWriteTimeout [NSError errorWithDomain:PAYMENT_DOMAIN code:writeTimeout userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic write timeout", NSLocalizedDescriptionKey, nil]]
#define characteristicNotSerilaizable [NSError errorWithDomain:PAYMENT_DOMAIN code:notSerializable userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic not serializable", NSLocalizedDescriptionKey, nil]]
#define characteristicReadNotSupported [NSError errorWithDomain:PAYMENT_DOMAIN code:readNotSupported userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic read not supported", NSLocalizedDescriptionKey, nil]]
#define characteristicWriteNotSupported [NSError errorWithDomain:PAYMENT_DOMAIN code:writeNotSupported userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic write not supported", NSLocalizedDescriptionKey, nil]]
#define characteristicNotifyNotSupported [NSError errorWithDomain:PAYMENT_DOMAIN code:notifyNotSupported userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic notify not supported", NSLocalizedDescriptionKey, nil]]
#define characteristicCommandFailure [NSError errorWithDomain:PAYMENT_DOMAIN code:commandFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic send command failure", NSLocalizedDescriptionKey, nil]]
#define characteristicCommandTimeout [NSError errorWithDomain:PAYMENT_DOMAIN code:commandFailure userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic send command timeout", NSLocalizedDescriptionKey, nil]]


// MARK: Peripheral
#define peripheralConnectTimeOut [NSError errorWithDomain:PAYMENT_DOMAIN code:connectTimeout userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Connect peripheral timeout", NSLocalizedDescriptionKey, nil]]
#define peripheralDisconnected [NSError errorWithDomain:PAYMENT_DOMAIN code:disconnected userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Peripheral disconnected", NSLocalizedDescriptionKey, nil]]
#define peripheralServiceDiscoveryTimeout [NSError errorWithDomain:PAYMENT_DOMAIN code:serviceDiscoveryTimeout userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Service discovery timeout", NSLocalizedDescriptionKey, nil]]
#define peripheralNoServices [NSError errorWithDomain:PAYMENT_DOMAIN code:noServices userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Peripheral services not found", NSLocalizedDescriptionKey, nil]]
#define peripheralServiceDiscoveryInProgress [NSError errorWithDomain:PAYMENT_DOMAIN code:serviceDiscoveryInProgress userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Service discovery in progress", NSLocalizedDescriptionKey, nil]]

// MARK: Central
#define centralIsScanning [NSError errorWithDomain:PAYMENT_DOMAIN code:isScanning userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Central is scannings", NSLocalizedDescriptionKey, nil]]
#define centralIsPoweredOff [NSError errorWithDomain:PAYMENT_DOMAIN code:isPoweredOff userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Central is powered off", NSLocalizedDescriptionKey, nil]]
#define centralRestoreFailed [NSError errorWithDomain:PAYMENT_DOMAIN code:restoreFailed userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error unpacking restored stat", NSLocalizedDescriptionKey, nil]]
#define centralPeripheralScanTimeout [NSError errorWithDomain:PAYMENT_DOMAIN code:peripheralScanTimeout userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Peripheral scan timeout", NSLocalizedDescriptionKey, nil]]
#define centralPeripheralRssiInvalid [NSError errorWithDomain:PAYMENT_DOMAIN code:peripheralScanTimeout userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"RSSI value is invalid", NSLocalizedDescriptionKey, nil]]
#define centralPeripheralDisconnected [NSError errorWithDomain:PAYMENT_DOMAIN code:isDisconnected userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Peripheral is disconnected", NSLocalizedDescriptionKey, nil]]



// MARK: Service
#define serviceCharacteristicDiscoveryTimeout [NSError errorWithDomain:PAYMENT_DOMAIN code:characteristicDiscoveryTimeout userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic discovery timeout", NSLocalizedDescriptionKey, nil]]
#define serviceCharacteristicDiscoveryInProgress [NSError errorWithDomain:PAYMENT_DOMAIN code:characteristicDiscoveryInProgress userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Characteristic discovery in progress", NSLocalizedDescriptionKey, nil]]
#define notExistingCharacteristic [NSError errorWithDomain:PAYMENT_DOMAIN code:notExistingCharacteristic userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Not existing characteristic!", NSLocalizedDescriptionKey, nil]]


// MARK: SDK
#define unactivatedDeviceError [NSError errorWithDomain:PAYMENT_DOMAIN code:unactivatedDeviceErr userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Please activate device first!", NSLocalizedDescriptionKey, nil]]


// MARK: Parameter
#define missingTicketIdParameter [NSError errorWithDomain:PAYMENT_DOMAIN code:missingTicketId userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Missiing ticketId parameter", NSLocalizedDescriptionKey, nil]]
#define missingAmountParameter [NSError errorWithDomain:PAYMENT_DOMAIN code:missingAmount userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Missiing amount parameter", NSLocalizedDescriptionKey, nil]]
#define missingParameter [NSError errorWithDomain:PAYMENT_DOMAIN code:missingParameter userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Missiing parameter", NSLocalizedDescriptionKey, nil]]
#define wrongParameterLength [NSError errorWithDomain:PAYMENT_DOMAIN code:wrongParameterLength userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Wrong parameter length", NSLocalizedDescriptionKey, nil]]



// MARK: BLE Command Error Code
#define wrongIvResult [NSError errorWithDomain:PAYMENT_DOMAIN code:wrongIvKey userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Wrong IV Key", NSLocalizedDescriptionKey, nil]]
#define ivKeyNotExist [NSError errorWithDomain:PAYMENT_DOMAIN code:noIvKey userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"There is no IvKey", NSLocalizedDescriptionKey, nil]]
#define activationResponseError [NSError errorWithDomain:PAYMENT_DOMAIN code:activationResponseErr userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Activation error", NSLocalizedDescriptionKey, nil]]
#define alreadyActivationResponseError [NSError errorWithDomain:PAYMENT_DOMAIN code:activationResponseErr userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Already is activated", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError01 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr01 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error01", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError02 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr02 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error02", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError03 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr03 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error03", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError04 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr04 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error04", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError05 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr05 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error05", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError06 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr06 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error06", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError07 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr07 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error07", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError08 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr08 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error08", NSLocalizedDescriptionKey, nil]]
#define paymentResponseError09 [NSError errorWithDomain:PAYMENT_DOMAIN code:paymentResponseErr09 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Payment device response error09", NSLocalizedDescriptionKey, nil]]
#define enableOtaError [NSError errorWithDomain:PAYMENT_DOMAIN code:enableOtaError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Enable firmware OTA error!", NSLocalizedDescriptionKey, nil]]
#define cleanLogError [NSError errorWithDomain:PAYMENT_DOMAIN code:cleanLogError userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Clean Transaction Log Error!", NSLocalizedDescriptionKey, nil]]


#define eTicketRedeemResponseError [NSError errorWithDomain:PAYMENT_DOMAIN code:eTicketResponseErr userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"E-Ticket redeem error", NSLocalizedDescriptionKey, nil]]



#endif /* PaymentError_h */
