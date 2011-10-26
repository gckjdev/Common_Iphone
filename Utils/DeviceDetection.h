//
//  DeviceDetection.h
//  three20test
//
//  Created by qqn_pipi on 10-4-14.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

enum {
	MODEL_UNKNOWN,
    MODEL_IPHONE_SIMULATOR,
    MODEL_IPOD_TOUCH,
	MODEL_IPOD_TOUCH_2G,
	MODEL_IPOD_TOUCH_3G,
	MODEL_IPOD_TOUCH_4G,
    MODEL_IPHONE,
	MODEL_IPHONE_3G,
	MODEL_IPHONE_3GS,
	MODEL_IPHONE_4G,
	MODEL_IPAD
};

@interface DeviceDetection : NSObject

+ (uint) detectDevice;
+ (int) detectModel;

+ (NSString *) returnDeviceName:(BOOL)ignoreSimulator;
+ (BOOL) isIPodTouch;
+ (BOOL) isOS4;
+ (BOOL) isOS5;
+ (BOOL) canSendSms;

@end