//
//  SettingDefinitionManager.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "SettingDefinitionManager.h"
#import "SettingGroup.h"
#import "SettingOptionValue.h"
#import "JSON.h"
#import "CoreDataUtil.h"
#import "StringUtil.h"

@implementation SettingDefinitionManager


+ (BOOL)createAppSettingFromString:(NSString*)appSettingsFile
{

	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	
	NSString *path = [[NSBundle mainBundle] pathForResource:appSettingsFile ofType:@"txt"];
	NSString* jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
	
	// parse JSON string and save to DB
	NSDictionary* dict = [jsonString JSONValue];
	NSArray* groups = [dict objectForKey:@"groups"];
	for (NSDictionary* group in groups){
		NSLog(@"Group Dict is %@", [group description]);
		
		SettingGroup* groupObject = [dataManager insert:@"SettingGroup"];
		groupObject.groupName = [group objectForKey:@"groupName"];
		groupObject.groupKey = [group objectForKey:@"groupKey"];
		groupObject.groupPosition = [[group objectForKey:@"groupPosition"] toNumber];
		groupObject.showInGUI = [[group objectForKey:@"showInGUI"] toNumber];
		
		// add settings in each group
		NSArray* groupSettingDefArray = [group objectForKey:@"settingDefinitions"];
		int index = 0;
		for (NSDictionary* groupSetting in groupSettingDefArray){
			
			SettingDefinition* sd = [dataManager insert:@"SettingDefinition"];
			sd.groupKey = groupObject.groupKey;
			sd.key = [groupSetting objectForKey:@"key"];
			sd.name = [groupSetting objectForKey:@"name"];
			sd.valueType = [groupSetting objectForKey:@"valueType"];
			sd.maxNumber = [[groupSetting objectForKey:@"maxNumber"] toNumber];
			sd.minNumber = [[groupSetting objectForKey:@"minNumber"] toNumber];
			sd.maxLength = [[groupSetting objectForKey:@"maxLength"] toNumber];
			sd.allowNull = [[groupSetting objectForKey:@"allowNull"] toNumber];
			sd.defaultValue = [groupSetting objectForKey:@"defaultValue"];
			sd.position = [NSNumber numberWithInt:index];

			// add value for each group
			NSArray* settingOptions = [groupSetting objectForKey:@"optionValues"];
			int valuePos = 0;
			for (NSString* optionValue in settingOptions){
				SettingOptionValue* value = [dataManager insert:@"SettingOptionValue"];
				value.key = sd.key;
				value.optionPosition = [NSNumber numberWithInt:valuePos];
				value.optionValue = optionValue;
				[sd addOptionValuesObject:value];		// add this option into setting
				valuePos ++;
			}
			
			// add this setting
			[groupObject addSettingDefinitionsObject:sd];
			
			index ++;
			
		}
	}
	
	if ([dataManager save] == YES){
		NSLog(@"createAppSettingFromString(%@) successfully", appSettingsFile);
	}
	else {
		NSLog(@"createAppSettingFromString(%@) failure", appSettingsFile);
	}

	
	return YES;
}
							
+ (NSArray*)getAllSettingGroups
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();	
	NSArray* allGroups = [dataManager execute:@"getAllSettingGroups" sortBy:@"groupPosition" ascending:YES];
	
	for (SettingGroup* group in allGroups){
		NSLog(@"group=%@", [group description]);
	}
	
	return allGroups;
}
							

@end
