//
//  HotKeywordManager.m
//  groupbuy
//
//  Created by LouisLee on 11-8-7.
//  Copyright 2011 ET. All rights reserved.
//

#import "HotKeywordManager.h"
#import "HotKeyword.h"
#import "CoreDataUtil.h"

@implementation HotKeywordManager

+ (void)createHotKeywords:(NSArray*)keywords
{
    
    // delete all old keywords first
    [HotKeywordManager deleteAllHotKeywords];
	
	for (NSString* keyword in keywords) {
		int i = 1;
		if (keyword!=nil) {
			HotKeyword *hotKeyword = [[HotKeyword alloc] initWithKeyword:keyword AndPriority:[NSNumber numberWithInt: i]];
			[HotKeywordManager createHotKeyword:hotKeyword];
			i++;
			[hotKeyword release];
		}
	}
}

+ (BOOL)createHotKeyword:(HotKeyword*)hotKeywordVal
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    HotKeyword *hotKeyword = [dataManager insert:@"HotKeyword"];
	hotKeyword.keyword = hotKeywordVal.keyword;
	hotKeyword.priority = hotKeywordVal.priority;
    return [dataManager save];
}

+ (NSArray*)getAllHotKeywords
{
	CoreDataManager* dataManager = GlobalGetCoreDataManager();
	return [dataManager execute:@"getAllHotKeywords"
                         sortBy:@"priority"
                      ascending:YES];
}

+ (BOOL) deleteAllHotKeywords
{
	CoreDataManager *dataManager = GlobalGetCoreDataManager();
    
    for (HotKeyword* keyword in [HotKeywordManager getAllHotKeywords]){
        [dataManager del:keyword];
    }
    
    return [dataManager save];     
}

@end
