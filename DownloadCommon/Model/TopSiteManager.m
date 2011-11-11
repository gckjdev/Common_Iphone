//
//  TopSiteManager.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopSiteManager.h"
#import "TopSite.h"
#import "DownloadNetworkConstants.h"

TopSiteManager *globalTopSiteManager;

@implementation TopSiteManager

@synthesize siteList;

- (void)dealloc
{
    [siteList release];
    [super dealloc];
}

+ (TopSiteManager*)defaultManager
{
    if (globalTopSiteManager == nil){
        globalTopSiteManager = [[TopSiteManager alloc] init];
    }
    
    return globalTopSiteManager;
}

- (void)updateData:(NSArray*)jsonArray
{
    self.siteList = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary* data in jsonArray){
        TopSite* site = [[TopSite alloc] initWithSiteId:[data objectForKey:PARA_SITE_ID]
                                               siteType:[[data objectForKey:PARA_TYPE] intValue]
                                           siteFileType:[data objectForKey:PARA_FILE_TYPE]
                                                siteURL:[data objectForKey:PARA_SITE_URL]
                                               siteName:[data objectForKey:PARA_SITE_NAME]
                                          downloadCount:[[data objectForKey:PARA_DOWNLOAD_COUNT] intValue]
                                            countryCode:[data objectForKey:PARA_COUNTRYCODE]];
        [siteList addObject:site];
    }
}

@end
