//
//  TopSiteManager.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopSiteManager.h"
#import "TopSite.h"
#import "Site.h"
#import "DownloadNetworkConstants.h"
#import "CoreDataUtil.h"
#import "LogUtil.h"
#import "StringUtil.h"
#import "LocaleUtils.h"

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

- (NSArray*)updateData:(NSArray*)jsonArray
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary* data in jsonArray){
        TopSite* site = [[TopSite alloc] initWithSiteId:[data objectForKey:PARA_SITE_ID]
                                               siteType:[[data objectForKey:PARA_TYPE] intValue]
                                           siteFileType:[data objectForKey:PARA_FILE_TYPE]
                                                siteURL:[data objectForKey:PARA_SITE_URL]
                                               siteName:[data objectForKey:PARA_SITE_NAME]
                                          downloadCount:[[data objectForKey:PARA_DOWNLOAD_COUNT] intValue]
                                            countryCode:[data objectForKey:PARA_COUNTRYCODE]];
        [dataList addObject:site];
    }
    
    return dataList;
}

- (NSArray*)findAllFavoriteSites
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return [dataManager execute:@"findAllFavoriteSites" forKey:@"USE_FOR" value:[NSNumber numberWithInt:SITE_USE_FOR_FAVORITE] sortBy:@"createDate" ascending:NO];
}

- (Site*)findSiteById:(NSString*)url
{
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    return (Site*)[dataManager execute:@"findSiteById" forKey:@"SITE_URL" value:url];    
}

- (Site*)addFavoriteSite:(NSString*)siteName siteURL:(NSString*)siteURL 
{
    Site* siteFound = [self findSiteById:siteURL];
    if (siteFound != nil){        
        PPDebug(@"addFavoriteSite (%@), already exist", siteURL);        
        return siteFound;
    }
    
    CoreDataManager* dataManager = [CoreDataManager dataManager];
    Site* site = [dataManager insert:@"Site"];

    site.siteType = [NSNumber numberWithInt:SITE_TYPE_LOCAL];
    site.siteName = siteName;
    site.siteURL = siteURL;
    site.siteId = [NSString GetUUID];
    site.countryCode = [LocaleUtils getCountryCode];
    site.useFor = [NSNumber numberWithInt:SITE_USE_FOR_FAVORITE];
    site.createDate = [NSDate date];
    site.deleteFlag = [NSNumber numberWithInt:0];
    
    PPDebug(@"create site = %@", [site description]);
    
    [dataManager save];    
    return site;

}

- (Site*)addFavoriteSite:(TopSite*)topSite
{
    Site* siteFound = [self findSiteById:topSite.siteURL];
    if (siteFound != nil){
        PPDebug(@"addFavoriteSite (%@), already exist", topSite.siteURL);
        return siteFound;
    }

    CoreDataManager* dataManager = [CoreDataManager dataManager];
    Site* site = [dataManager insert:@"Site"];
    
    site.siteType = [NSNumber numberWithInt:SITE_TYPE_LOCAL];
    site.siteName = topSite.siteName;
    site.siteURL = topSite.siteURL;
    site.siteId = topSite.siteId;
    site.countryCode = topSite.countryCode;
    site.siteFileType = topSite.siteFileType;
    site.useFor = [NSNumber numberWithInt:SITE_USE_FOR_FAVORITE];
    site.createDate = [NSDate date];
    site.deleteFlag = [NSNumber numberWithInt:0];
    
    PPDebug(@"create site = %@", [site description]);
    
    [dataManager save];    
    return site;
}

@end
