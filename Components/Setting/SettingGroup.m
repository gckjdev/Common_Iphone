// 
//  SettingGroup.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "SettingGroup.h"
#import "LocaleUtils.h"

@implementation SettingGroup 

@dynamic groupName;
@dynamic groupKey;
@dynamic groupPosition;
@dynamic settingDefinitions;
@dynamic showInGUI;

- (NSString*)description
{
	NSString* str = [super description];
	for (SettingDefinition* sd in self.settingDefinitions){
		str = [str stringByAppendingFormat:@"\nItem:%@", [sd description]];
	}	
	
	return str;
}

- (NSString*)localizedName
{
	return NSLS(self.groupName);
}

- (SettingDefinition*)getSettingDefinition:(int)index
{
	if (index >= 0 && index < [self.settingDefinitions count]){
		return [[self getAllSettingDefinitions] objectAtIndex:index];
	}
	else {
		return nil;
	}

}

- (NSArray*)getAllSettingDefinitions
{
	NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
	NSArray* sortArray = [NSArray arrayWithObject:sortDesc];
	return [self.settingDefinitions sortedArrayUsingDescriptors:sortArray];	
}


@end
