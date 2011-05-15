//
//  SettingGroup.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SettingDefinition.h"

@interface SettingGroup :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupKey;
@property (nonatomic, retain) NSNumber * groupPosition;
@property (nonatomic, retain) NSSet* settingDefinitions;
@property (nonatomic, retain) NSNumber * showInGUI;

- (NSString*)localizedName;

@end

// coalesce these into one @interface SettingGroup (CoreDataGeneratedAccessors) section
@interface SettingGroup (CoreDataGeneratedAccessors)
- (void)addSettingDefinitionsObject:(SettingDefinition *)value;
- (void)removeSettingDefinitionsObject:(SettingDefinition *)value;
- (void)addSettingDefinitions:(NSSet *)value;
- (void)removeSettingDefinitions:(NSSet *)value;

- (SettingDefinition*)getSettingDefinition:(int)index;
- (NSArray*)getAllSettingDefinitions;

@end



