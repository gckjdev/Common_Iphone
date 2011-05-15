//
//  SettingManager.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "Setting.h"
#import "SettingManager.h"
#import "CoreDataUtil.h"
#import "StringUtil.h"
#import "SettingDefinition.h"

// used by app to access key-value of settings
@implementation SettingManager

+ (id)getSettingObject:(NSString*)key
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	id value = [dataManager execute:@"getSettingByKey" forKey:@"key" value:key];
	return value;
}

+ (id)getSettingDefinitionObject:(NSString*)key
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	id value = [dataManager execute:@"getSettingDefinitionByKey" forKey:@"key" value:key];
	return value;
}

+ (id)getValue:(NSString*)key
{
	id value = nil;
	id object = [SettingManager getSettingObject:key];
	if (object == nil){

		// if setting value not found, try to get default value and return the default value
		object = [SettingManager getSettingDefinitionObject:key];
		if (object == nil)
			return nil;
		
		value = [object defaultValue];
	}
	else {
		value = [object value];
	}	
	
	return value;
}

+ (NSString*)getBoolString:(BOOL)value
{
	if (value == YES){
		return kOnString;
	}
	else {
		return kOffString;
	}

}

+ (NSString*)getStringValue:(NSString*)key
{
	id value = [SettingManager getValue:key];
	
	SettingDefinition* sd = [SettingManager getSettingDefinitionObject:key];
	if (!sd)
		return nil;
	if ([sd isBoolType]){
		return [SettingManager getBoolString:[value boolValue]];	
	}

	if ([value isKindOfClass:[NSString class]])
		return value;
	else if ([value isKindOfClass:[NSNumber class]])
		return [value stringValue];
	else if (value == nil)
		return nil;
	else
		return [value description];
}

+ (BOOL)getBoolValue:(NSString*)key
{
	id value = [SettingManager getValue:key];
	if ([value isKindOfClass:[NSString class]])
		return [value boolValue];
	else if ([value isKindOfClass:[NSNumber class]])
		return [value boolValue];
	else if (value == nil)
		return NO;
	else
		return NO;
}

+ (int)getIntValue:(NSString*)key
{
	id value = [SettingManager getValue:key];
	if ([value isKindOfClass:[NSString class]])
		return [value intValue];
	else if ([value isKindOfClass:[NSNumber class]])
		return [value intValue];
	else if (value == nil)
		return 0;
	else
		return 0;
}

// get setting object by key, create the object if not found
+ (Setting*)getOrCreateSetting:(NSString*)key
{
	Setting* object = [SettingManager getSettingObject:key];
	if (object == nil){
		// object not found, create a new object
		object = [[CoreDataManager dataManager] insert:@"Setting"];
		if (object == nil)
			return nil;
		
		object.key = key;
	}

	return object;
}

+ (BOOL)setStringValue:(NSString*)value forKey:(NSString*)key
{
	Setting* object = [SettingManager getOrCreateSetting:key];
	if (object == nil)
		return NO;
	
	// set data
	object.value = value;
	object.updateDate = [NSDate date];
	
	// save
	[[CoreDataManager dataManager] save];

	return YES;
}

+ (BOOL)setIntValue:(int)value forKey:(NSString*)key
{
	Setting* object = [SettingManager getOrCreateSetting:key];
	if (object == nil)
		return NO;
	
	// set data
	object.value = [NSString stringWithInt:value];
	object.updateDate = [NSDate date];
	
	// save
	[[CoreDataManager dataManager] save];
	
	return YES;
}

+ (BOOL)setBoolValue:(BOOL)value forKey:(NSString*)key
{
	Setting* object = [SettingManager getOrCreateSetting:key];
	if (object == nil)
		return NO;
	
	// set data
	object.value = [NSString stringWithInt:value];
	object.updateDate = [NSDate date];
	
	// save
	[[CoreDataManager dataManager] save];

	return YES;
}

+ (void)printAllSettings
{
	NSLog(@"<printAllSettings> START");
	NSArray* allSettings = [[CoreDataManager dataManager] execute:@"getAllSettings"];
	for (Setting* setting in allSettings){
		NSLog(@"\t%@ = %@", setting.key, setting.value);
	}
	NSLog(@"<printAllSettings> END");
}

@end
