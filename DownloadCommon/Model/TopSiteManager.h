//
//  TopSiteManager.h
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Site;
@class TopSite;

@interface TopSiteManager : NSObject

@property (nonatomic, retain) NSMutableArray* siteList;

+ (TopSiteManager*)defaultManager;

- (NSArray*)updateData:(NSArray*)jsonArray;

- (Site*)addFavoriteSite:(NSString*)siteName siteURL:(NSString*)siteURL;
- (Site*)addFavoriteSite:(TopSite*)topSite;

- (NSArray*)findAllFavoriteSites;
- (Site*)findSiteById:(NSString*)url;

@end
