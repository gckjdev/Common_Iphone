//
//  GroupDataAZ.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-9.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "GroupDataAZ.h"
#import "pinyin.h"
#import "StringUtil.h"

@implementation GroupDataAZ

@synthesize totalSectionCount;
@synthesize sectionLetterDict;
@synthesize dataSectionArray;
@synthesize sectionTitleArray;

- (NSString*)getObjectString:(NSObject*)obj
{
	if (obj == nil)
		return nil;
	
	if ([obj isKindOfClass:[NSString class]]){
		return (NSString*)obj;
	}
	else {
		if ([obj respondsToSelector:@selector(stringForGroup)]){
			return [obj performSelector:@selector(stringForGroup)];
		}
		else {
			NSLog(@"<warning> Group Data But stringForGroup not implemented");
		}

	}
	
	return nil;
}

- (BOOL)addObjectToSection:(NSString*)sectionTitle object:(NSObject*)object
{
	NSMutableArray* rowArray = nil;
	NSNumber* section = [self.sectionLetterDict objectForKey:[sectionTitle uppercaseString]];
	int sectionIndex = [section intValue];
	if (section == nil){
		// section not found, create the section
		rowArray = [[[NSMutableArray alloc] init] autorelease];
		[self.dataSectionArray addObject:rowArray];
		int insertIndex = [self.dataSectionArray count] - 1;
		[self.sectionLetterDict setObject:[NSNumber numberWithInt:insertIndex] forKey:[sectionTitle uppercaseString]];
		[self.sectionTitleArray addObject:[sectionTitle uppercaseString]];
	}
	else {
		rowArray = [self.dataSectionArray objectAtIndex:sectionIndex];
	}
	
	[rowArray addObject:object];	
	return YES;
}

- (void)printData
{
	NSLog(@"==== print data array ======");
	for (NSArray* array in self.dataSectionArray){
		NSLog(@"==== new array ======");
		for (NSObject* obj in array){
			NSLog(@"object=%@", [self getObjectString:obj]);
		}
	}
	
	NSArray* keys = [self.sectionLetterDict allKeys];
	for (int i=0; i<[keys count]; i++){
		NSLog(@"key=%@, value=%d", [keys objectAtIndex:i], [[self.sectionLetterDict objectForKey:[keys objectAtIndex:i]] intValue]);
	}
}

// create the object
+ (id)GroupDataWithArray:(NSArray*)originDataList
{
	GroupDataAZ *groupData = [[[GroupDataAZ alloc] init] autorelease];		
	
	if (originDataList == nil || [originDataList count] == 0){
		groupData.totalSectionCount = 0;
		groupData.sectionLetterDict = nil;
		groupData.dataSectionArray = nil;
		return groupData;
	}

	groupData.sectionLetterDict = [[NSMutableDictionary alloc] init];
	groupData.dataSectionArray = [[NSMutableArray alloc] init];
	groupData.sectionTitleArray = [[NSMutableArray alloc] init];
	
	for (NSObject* obj in originDataList){
		
		NSString* sectionTitle = nil;
		NSString* objstr = [groupData getObjectString:obj];
		if (objstr == nil || [objstr length] == 0){
			// belong to null section if object string is NULL or empty
			sectionTitle = kSectionNull;
		}
		else {
			sectionTitle = pinyinStringFirstLetter([objstr characterAtIndex:0]);
			if (sectionTitle == nil || [sectionTitle length] == 0){
				sectionTitle = kSectionNull;
			}
		}

		[groupData addObjectToSection:sectionTitle object:obj];		
		
//		NSLog(@"<Debug> add object(%@) into section(%@)", objstr, sectionTitle);
	}
	
	groupData.totalSectionCount = [groupData.dataSectionArray count];
	
//	[groupData printData];
	
	return groupData;
}

- (NSString*)titleForSection:(int)section
{
	if (section >= 0 && section < [sectionTitleArray count]){
		return [sectionTitleArray objectAtIndex:section];
	}
	else {
		return @"";
	}

}

// return data object by given (section,row)
- (NSObject*)dataForSection:(int)section row:(int)row
{
	if (section < 0 || section > ([dataSectionArray count] - 1)){
		return nil;
	}
	
	NSArray* rowArray = [dataSectionArray objectAtIndex:section];
	if (rowArray == nil || row < 0 || row > ([rowArray count] - 1)){
		return nil;
	}
	
	return [rowArray objectAtIndex:row];
}

// return section index by given letter
// for example, "A" return 0, "C" return 2, and "Z" return 3
- (int)sectionForLetter:(NSString*)letter
{
	if (letter == nil)
		return kSectionNotFound;
	
	NSNumber *sectionNumber = [sectionLetterDict objectForKey:letter];
	return [sectionNumber intValue];
}

- (int)numberOfRowsInSection:(NSInteger)section
{
	if (section >= 0 && section < [dataSectionArray count])
		return [[dataSectionArray objectAtIndex:section] count];
	else {
		return 0;
	}

}

- (void)dealloc
{
	[sectionLetterDict release];
	[dataSectionArray release];
	[sectionTitleArray release];
	[super dealloc];
}

@end
