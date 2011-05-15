//
//  SettingDefinition.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#define kSettingValueTypeString		@"String"
#define kSettingValueTypeInt		@"Int"
#define kSettingValueTypeList		@"List"
#define kSettingValueTypeBool		@"Bool"

@class SettingOptionValue;
@class SettingGroup;

@interface SettingDefinition :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * valueType; 
@property (nonatomic, retain) NSNumber * maxNumber;
@property (nonatomic, retain) NSString * defaultValue;
@property (nonatomic, retain) NSNumber * minNumber;
@property (nonatomic, retain) NSNumber * maxLength;
@property (nonatomic, retain) NSString * groupKey;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * allowNull;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) SettingGroup * group;
@property (nonatomic, retain) NSSet* optionValues;
@property (nonatomic, retain) NSNumber * position;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addOptionValuesObject:(SettingOptionValue *)value;
- (void)removeOptionValuesObject:(SettingOptionValue *)value;

- (NSArray*)getOptionStringValues;

- (BOOL)isStringType;
- (BOOL)isIntType;
- (BOOL)isListType;
- (BOOL)isBoolType;

- (BOOL)requireSingleLine;
- (NSString*)localizedName;


@end



// coalesce these into one @interface SettingDefinition (CoreDataGeneratedAccessors) section
@interface SettingDefinition (CoreDataGeneratedAccessors)
- (void)addOptionValuesObject:(SettingOptionValue *)value;
- (void)removeOptionValuesObject:(SettingOptionValue *)value;
- (void)addOptionValues:(NSSet *)value;
- (void)removeOptionValues:(NSSet *)value;

@end

