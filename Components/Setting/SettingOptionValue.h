//
//  SettingOptionValue.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SettingDefinition;

@interface SettingOptionValue :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * optionPosition;
@property (nonatomic, retain) NSString * optionValue;
@property (nonatomic, retain) SettingDefinition * settingDefinition;

- (NSString*)textForCellDisplay;

@end



