//
//  SearchHistoryManager.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SearchHistoryManager.h"
#import "CoreDataUtil.h"
#import "SearchHistory.h"

@implementation SearchHistoryManager

+ (BOOL)createSearchHistory:(NSString*)keyword
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    
    // find keywords
    SearchHistory* history = [SearchHistoryManager findSearchHistoryByKeyword:keyword];
    if (history == nil){    
        history = [dataManager insert:@"SearchHistory"];
        history.keywords = keyword;
    }

    history.lastModified = [NSDate date];    
	NSLog(@"<createSearchHistory> history=%@", [history description]);
    return [dataManager save];
}

+ (SearchHistory*)findSearchHistoryByKeyword:(NSString*)keyword
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
    return (SearchHistory*)[dataManager execute:@"findSearchHistoryByKeyword" forKey:@"KEYWORDS" value:keyword];
}


+ (NSArray*)getLatestSearchHistories
{
    CoreDataManager* dataManager = GlobalGetCoreDataManager();
	return [dataManager execute:@"getLatestSearchHistories"
                         sortBy:@"lastModified"
                      ascending:NO];    
    
}

@end
