//
//  HotKeywordManager.h
//  groupbuy
//
//  Created by LouisLee on 11-8-7.
//  Copyright 2011 ET. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HotKeyword;

@interface HotKeywordManager : NSObject {

}

+ (void)createHotKeywords:(NSArray*)keywords;
+ (BOOL)createHotKeyword:(NSString*)keyword priority:(int)priority;
+ (NSArray*)getAllHotKeywords;
+ (BOOL) deleteAllHotKeywords;
@end
