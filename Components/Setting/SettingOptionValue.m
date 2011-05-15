// 
//  SettingOptionValue.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "SettingOptionValue.h"


@implementation SettingOptionValue 

@dynamic key;
@dynamic optionPosition;
@dynamic optionValue;
@dynamic settingDefinition;

- (NSString*)description
{
	return [NSString stringWithFormat:@"Option : key(%@), value(%@), position(%@)", self.key, self.optionValue, [self.optionPosition description]];
}

- (NSString*)textForCellDisplay
{
	return self.optionValue;
}

@end
