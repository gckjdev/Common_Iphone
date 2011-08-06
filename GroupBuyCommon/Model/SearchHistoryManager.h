//
//  SearchHistoryManager.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchHistory;

@interface SearchHistoryManager : NSObject {
    
}

+ (BOOL)createSearchHistory:(NSString*)keyword;
+ (SearchHistory*)findSearchHistoryByKeyword:(NSString*)keyword;
+ (NSArray*)getLatestSearchHistories;
@end
