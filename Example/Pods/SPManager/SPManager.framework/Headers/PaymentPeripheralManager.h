//
//  PaymentManager.h
//  SecuXPaymentPeripheral
//
//  Created by SecuX on 2019/09/20.
//  Copyright © 2019年 SecuX Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDKConstant.h"


@class PaymentPeripheralManager;
/**
 *  Delegate protocol for paymentManager
 */
@protocol PaymentPeripheralManagerDelegate <NSObject>


@required
/**
 *  User turn off Bluetooth setting
 */
- (void) poweredOff;
/**
 * User doesn't authorize BT to this App
 */

- (void) notAutohrized;


/**
 *  did payment  service disconnect.
 */

- (void)didDisconnectPeripheral;

@end


@interface PaymentPeripheralManager : NSObject

//- (instancetype) init;

- (instancetype) initWithAlertview:(BOOL)showAlertview;

@property (nonatomic, assign) id<PaymentPeripheralManagerDelegate>       delegate;

//* Common API */

/**
Discover nearby peripherals

@param scanInterval seconds to discover nearby peripherals
@param checkRSSI minimun RSSI signal strength value to check
@param completedBlock complete block
*/
-(void)discoverNearbyPeripherals :(double)scanInterval checkRSSI:(int)checkRSSI withCompletedBlock:(BleScanCompleteBlock)completedBlock;

/**
 Discover nearby peripheral by RSSI signal strength. It's more like near field detection. This method will return founded peripheral immediately.
 
 @param checkRSSI minimun RSSI signal strength value to check
 @param completedBlock complete block
 */
-(void)discoverNearbyPeripheralBySignalStrength :(int)checkRSSI withCompletedBlock:(BleScanCompleteBlock)completedBlock;

/**
 Discover nearby peripheral by RSSI signal strength and peripheral uniqueId.  This method will return founded peripheral immediately.
 
 @param timeout timeout secconds to abort discovering action
 @param scanDeviceId peripheral uniqueId to discover
 @param checkRSSI minimun RSSI signal strength value to check
 @param completedBlock complete block
 */
-(void)discoverNearbySpecificPeripheral:(double)timeout scanDeviceId:(NSString *)scanDeviceId checkRSSI:(int)checkRSSI withCompletedBlock:(BleScanCompleteBlock)completedBlock;

/**
     Stop Nearyby discover APIs
*/
-(void)stopNearbyDiscover;

/**
 Verify Peripheral Authenticity

 @param scanTimeout discover peripheral timeout seconds
 @param connectDeviceId peripheral device id to activate
 @param checkRSSI minimun RSSI signal strength value to check
 @param connectionTimeout peripheral connection timeout seconds
 @param completedBlock complete block
 */
-(void)doPeripheralAuthenticityVerification:(double)scanTimeout connectDeviceId:(NSString *)connectDeviceId checkRSSI:(int)checkRSSI connectionTimeout:(double)connectionTimeout  withCompletedBlock:(BleSendStringCompleteBlock)completedBlock;


/**
 Get Peripheral IV key
 
  @param completedBlock complete block
 */
-(void)doGetIvKey:(BleGetStringCompleteBlock)completedBlock;

//* Payment APIs */

/**
    machineControlParams parameter value
     gpio1: 1~524287
     gpio2: 1~524287
     gpio31: reserved for future usage
     gpio32: reserved for future usage
     gpio4: 1~39999ms
     gpio4c: 20 ~ 39999 ms
     gpio4cInterval: 20~39999 ms
     gpoo4cCount: 1~50
     gpio4dOn: 20~200 ms
     gpio4dOff: 20~200 ms
     gpio4dInterval: 100~10000 ms
     uart: 4 bytes
 */

-(void)doPaymentVerification:  (NSData*)encryptedData  machineControlParams:(NSDictionary *)machineControlParams withCompletedBlock:(BleGetDictionayCompleteBlock)completedBlock;


/**
 Enable firmware OTA mode
 */
-(void)doPeripheralEnableOTA:(double)timeout connectDeviceId:(NSString *)connectDeviceId checkRSSI:(int)checkRSSI withCompletedBlock:(BleCompleteBlock)completedBlock;

/**
Enable firmware OTA mode
*/

-(void)doPeripheralCleanLog:(double)timeout connectDeviceId:(NSString *)connectDeviceId checkRSSI:(int)checkRSSI withCompletedBlock:(BleCompleteBlock)completedBlock;

/**
 Cancel connection between App and BLE peripheral
 */
-(void)cancelConnection;


/**
 Get machine control command
 */
-(NSString *)getMachineControlCommand: (NSDictionary *)machineControlParams;

/**
 Activate Peripheral
 
 @param timeout seconds to timeout this method
 @param connectDeviceId peripheral device id to activate
 @param checkRSSI minimun RSSI signal strength value to check
 @param configuration configuration information from server to store in peripheral
 @param completedBlock complete block
 */
-(void)doPeripheralActivation:(double)timeout connectDeviceId:(NSString *)connectDeviceId checkRSSI:(int)checkRSSI configuration:(NSDictionary *)configuration withCompletedBlock:(BleCompleteBlock)completedBlock;

-(void)doPeripheralReActivation:(double)timeout connectDeviceId:(NSString *)connectDeviceId checkRSSI:(int)checkRSSI oldConfiguration:(NSDictionary *)oldConfiguration configuration:(NSDictionary *)configuration withCompletedBlock:(BleCompleteBlock)completedBlock;

@end
