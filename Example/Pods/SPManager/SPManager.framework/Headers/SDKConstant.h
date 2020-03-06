//
//  SDKConstant.h
//  SecuXPaymentPeripheral
//
//  Created by SecuX on 2019/09/20.
//  Copyright © 2019年 SecuX Technology Inc. All rights reserved.
//

#ifndef SDKConstant_h
#define SDKConstant_h

typedef void (^BleScanCompleteBlock)(NSMutableArray* foundPeripherals, NSError* error );
typedef void (^BleConnectCompleteBlock)(NSError* error );
typedef void (^BleSendDataCompleteBlock)(NSData* returnData, NSError* error );
typedef void (^BleCompleteBlock)(NSError* error );
typedef void (^BleSendStringCompleteBlock)(NSString* returnStr, NSError* error );
typedef void (^BleGetStringCompleteBlock)(NSString* returnStr, NSError* error );
typedef void (^BleGetDictionayCompleteBlock)(NSDictionary* returnDict, NSError* error );
typedef void (^BleCheckStampModeCompleteBlock)(BOOL isStampModeOn, NSError* error );


#define RUN_IO          "0"
#define STOP_IO         "1"
#define REVERSE_IO      "2"


#define LOCK_IO         "1"
#define UNLOCK_IO       "0"


#endif /* SDKConstant_h */
