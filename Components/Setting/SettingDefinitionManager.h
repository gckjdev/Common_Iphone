//
//  SettingDefinitionManager.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// use for define your app settings (including group and settings in the group)
@interface SettingDefinitionManager : NSObject {

}

/*
	appSettingString : JSON definition 

 {"Group":[
 
	 {
	  "groupKey":"defaultGroup", 
	  "groupName":"", 
	  "groupPosition":"1", 
	  "settingDefinitions":
		[
			{	
				"key":"allowLogin",
				"name":"Allow Login",
				"valueType":"String",
				"maxNumber":"0",
				"minNumber":"0",
				"defaultValue":"",
				"maxLength":"99999999",
				"allowNull":"1",
				"optionValues":["value1", "value2", "value3"]
			},
		 
			{
				 "key":"allowLogin",
				 "name":"Allow Login",
				 "valueType":"String",
				 "maxNumber":"0",
				 "minNumber":"0",
				 "defaultValue":"",
				 "maxLength":"99999999",
				 "allowNull":"1",
				 "optionValues":["value1", "value2", "value3"]
		 
			}
		]
	 }
 
 
 ]}
 
*/
+ (BOOL)createAppSettingFromString:(NSString*)appSettingsFile;

+ (NSArray*)getAllSettingGroups;

@end
