//
//  TopDownloadManager.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopDownloadManager.h"
#import "TopDownloadItem.h"
#import "DownloadNetworkConstants.h"
#import "CoreDataUtil.h"

TopDownloadManager *globalTopDownloadManager;

@implementation TopDownloadManager

@synthesize siteList;

- (void)dealloc
{
    [siteList release];
    [super dealloc];
}


+ (TopDownloadManager *)defaultManager
{
    if (globalTopDownloadManager == nil) {
        globalTopDownloadManager = [[TopDownloadManager alloc] init];
    }
    return globalTopDownloadManager;
}

- (NSArray*)updateData:(NSArray*)jsonArray
{
    NSMutableArray* dataList = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary* data in jsonArray){
        TopDownloadItem* site = [[TopDownloadItem alloc] initWithFileType:[data             objectForKey:PARA_FILE_TYPE] 
                                fileName:[data objectForKey:PARA_FILE_NAME] 
                                url:[data objectForKey:PARA_FILE_URL] 
                                webSite:[data objectForKey:PARA_SITE_URL]                                                               
                                webSiteName:[data objectForKey:PARA_SITE_NAME]  
                                totalDownload:[[data objectForKey:PARA_DOWNLOAD_COUNT] intValue]
                               rank:[[data objectForKey:PARA_RANK] intValue]
                            score:[[data objectForKey:PARA_SCORE] floatValue]
                            createDate:[data objectForKey:PARA_CREATE_DATE] modifyDate:[data objectForKey:PARA_MODIFY_DATE] 
                                countryCode:[data objectForKey:PARA_COUNTRYCODE] language:[data objectForKey:PARA_LANGUAGE]];
                                               
        [dataList addObject:site];
    }
    
    return dataList;
}

@end
