// 
//  SettingDefinition.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "SettingDefinition.h"
#import "SettingOptionValue.h"
#import "LocaleUtils.h"

@implementation SettingDefinition 

@dynamic valueType;
@dynamic maxNumber;
@dynamic defaultValue;
@dynamic minNumber;
@dynamic maxLength;
@dynamic groupKey;
@dynamic key;
@dynamic allowNull;
@dynamic name;
@dynamic group;
@dynamic optionValues;
@dynamic position;

- (void)addOptionValuesObject:(SettingOptionValue *)value 
{    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"optionValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"optionValues"] addObject:value];
    [self didChangeValueForKey:@"optionValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeOptionValuesObject:(SettingOptionValue *)value 
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"optionValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"optionValues"] removeObject:value];
    [self didChangeValueForKey:@"optionValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (NSString*)description
{
	NSString* str = [super description];
	for (SettingOptionValue* value in self.optionValues){
		str = [str stringByAppendingFormat:@"\nItem:%@", [value description]];
	}	
	
	return str;
}

- (BOOL)isStringType
{
	return [self.valueType caseInsensitiveCompare:kSettingValueTypeString] == NSOrderedSame;		
}

- (BOOL)isIntType
{
	return [self.valueType caseInsensitiveCompare:kSettingValueTypeInt] == NSOrderedSame;		
}

- (BOOL)isListType
{
	return [self.valueType caseInsensitiveCompare:kSettingValueTypeList] == NSOrderedSame;		
}

- (BOOL)isBoolType
{
	return [self.valueType caseInsensitiveCompare:kSettingValueTypeBool] == NSOrderedSame;		
}

- (BOOL)requireSingleLine
{
	static int kMaxLengthPerLine = 25;
	
	if ([self.maxLength intValue] > kMaxLengthPerLine){
		return NO;
	}
	else {
		return YES;
	}

}

- (NSString*)localizedName
{
	return NSLS(self.name);
}

- (NSArray*)getOptionStringValues
{
	NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"optionPosition" ascending:YES];
	NSArray* sortArray = [NSArray arrayWithObject:sortDesc];
	return [self.optionValues sortedArrayUsingDescriptors:sortArray];
}

@end
