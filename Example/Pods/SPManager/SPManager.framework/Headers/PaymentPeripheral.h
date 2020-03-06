//
//  PaymentPeripheral.h
//  PaymentPeripheralExample
//
//  Created by SecuX on 2019/09/20.
//  Copyright © 2019年 SecuX Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SDKConstant.h"

#define MIN_RSSI_IMMEDIATE -50
#define MAX_RSSI_IMMEDIATE   0
#define MIN_RSSI_NEAR      -80
#define MAX_RSSI_NEAR      -50
#define MAX_RSSI_FAR       -80

@interface PaymentPeripheral : NSObject
{
    CBPeripheral     *peripheral;        // BLE peripheral information for this beacon
    NSString        *uniqueId;          // unique Id of BLE chip
    NSString        *deviceName;        // device name
    int             proximity;          // proximity indicator
    // Immediate: rssi is between 0 ~ -50
    // Near: rssi is between -50 ~ -80
    // Far: rssi is less than -80
    // Unknown: rssi is not Immediate, Near or far
    NSDictionary    *bleAdvertisementData;
    NSNumber        *lastRssi;          // rssi value when discovery
    NSNumber        *minRssi;          // min rssi value when discovery
    NSDate          *lastDiscoveryTime; // device discovery time
    BOOL            isValidDevice;      // valid device
    NSString        *firmwareVersion;   // firmeware version of this peripheral
}


/**
 *  BLE peripheral information for this beacon
 */
@property (nonatomic, readonly) CBPeripheral *peripheral;

/**
 *  unique Id of BLE chip.
 */
@property (nonatomic, readonly) NSString *uniqueId;
/**
 *   device name
 */
@property (nonatomic, readonly) NSString *deviceName;
/**
 *  proximity indicator
 *
 *  Immediate: rssi is between 0 ~ -50
 *  Near: rssi is between -50 ~ -80
 *  Far: rssi is less than -80
 *  Unknown: rssi is not Immediate, Near or far
 */
@property (nonatomic, readonly) int proximity;
/**
 *  rssi value when discovery
 */
@property (nonatomic, readonly) NSNumber *lastRssi;
/**
 *  minimun rssi value when discovery
 */
@property (nonatomic, readonly) NSNumber *minRssi;
/**
 *  device discovery time
 */
@property (nonatomic, readonly) NSDate *lastDiscoveryTime;


/**
 * Firmware Version
 */
@property (nonatomic, readonly) NSString *firmwareVersion;

/**
 *  advertisementData from BLE device
 */
@property (nonatomic, readonly) NSDictionary    *bleAdvertisementData;

/**
 *  flag to indicate device is activated or not
 */
@property (nonatomic, readonly) BOOL  isActivated;

/**
 *  init PaymentPeripheral class
 *
 *  @param discoverdPeripheral    discoverd payment peripheral
 *  @param advertisementData payment peripheral BLE advertisement data
 *  @param RSSI              rssi value
 *
 *  @return PaymentPeripheral object
 */
- (instancetype) initWithPeripheral:(CBPeripheral *)discoverdPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

-(NSData *)getSecuxValidatePeripheralCommand:(int)timeout;

-(BOOL)isValidPeripheralIvKey:(uint8_t *)cipher_code_q1;
-(BOOL)isCorrectResponseValue:(uint8_t *)responseCode;
-(NSString *)getSecuxEnableOTAHash;

@end
