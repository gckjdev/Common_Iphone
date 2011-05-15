//
//  SettingManager.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingManager : NSObject {

}

+ (NSString*)getStringValue:(NSString*)key;
+ (BOOL)getBoolValue:(NSString*)key;
+ (int)getIntValue:(NSString*)key;

+ (BOOL)setStringValue:(NSString*)value forKey:(NSString*)key;
+ (BOOL)setIntValue:(int)value forKey:(NSString*)key;
+ (BOOL)setBoolValue:(BOOL)value forKey:(NSString*)key;

+ (void)printAllSettings;

@end
