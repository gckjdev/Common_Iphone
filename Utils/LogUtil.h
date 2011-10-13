//
//  LogUtil.h
//  three20test
//
//  Created by qqn_pipi on 10-3-30.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
    #define PPDebug(format, ...) NSLog(format, ## __VA_ARGS__)
#else
    #define PPDebug(format, ...)
#endif

@interface LogUtil : NSObject {

}

+ (void)startLog:(NSString*)string;
+ (void)stopLog:(NSString*)string;

@end
