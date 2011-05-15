//
//  SearchHistoryManager.m
//  three20test
//
//  Created by qqn_pipi on 10-4-7.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "SearchHistoryManager.h"


@implementation SearchHistoryManager

+ (NSMutableArray*)getHistoryText:(NSString*)key
{
	return [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
}

+ (BOOL)addHistoryText:(NSString*)key text:(NSString*)text
{
	static int kMaxRecordInHistory = 25;
	
	if (key == nil || text == nil || [text length] == 0)
		return NO;
	
	NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];
	
	NSMutableArray* newArray = [NSMutableArray arrayWithArray:array];

	BOOL found = NO;
	int  i = 0;
	int  count = [newArray count];
	for (i=0; i<count; i++){
		NSString* record = [newArray objectAtIndex:i];
		if ([text isEqualToString:record] == YES){
			found = YES;
			break;
		}
	}
	
	if (found == YES){
		// avoid duplicate record, remove object firstly
		[newArray removeObjectAtIndex:i];
	}	
	
	[newArray insertObject:text atIndex:0];
	
	if ([newArray count] > kMaxRecordInHistory){
		[newArray removeLastObject];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:newArray forKey:key];
	
	return YES;
}

+ (BOOL)clearAllHistory:(NSString*)key
{
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
	return YES;
}

+ (BOOL)deleteTextFromHistory:(NSString*)key text:(NSString*)text
{
	NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];	
	NSMutableArray* newArray = [NSMutableArray arrayWithArray:array];
	
	BOOL found = NO;
	int  i;
	int  count = [newArray count];
	for (i=0; i<count; i++){
		if ( [text isEqualToString:[newArray objectAtIndex:i]] == YES ){
			found = YES;
			break;
		}
	}
	
	if (found){
		[newArray removeObjectAtIndex:i];
		[[NSUserDefaults standardUserDefaults] setObject:newArray forKey:key];		
	}
	
	return YES;
}

+ (void)deleteLastRecord:(int)maxRecordToKeep key:(NSString*)key
{
	NSArray* array = [[NSUserDefaults standardUserDefaults] arrayForKey:key];	
	NSMutableArray* newArray = [NSMutableArray arrayWithArray:array];	
	
	int count = [newArray count];
	if (maxRecordToKeep < count){
		NSRange range;
		range.length = count - maxRecordToKeep;
		range.location = maxRecordToKeep;
		[newArray removeObjectsInRange:range];
		[[NSUserDefaults standardUserDefaults] setObject:newArray forKey:key];			
	}
}

@end
