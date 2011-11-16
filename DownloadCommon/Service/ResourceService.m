//
//  ResourceService.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ResourceService.h"
#import "DownloadNetworkRequest.h"
#import "DownloadNetworkConstants.h"
#import "LocaleUtils.h"
#import "PPNetworkRequest.h"
#import "TopSiteManager.h"
#import "TopSite.h"
#import "TopDownloadManager.h"
#import "TopDownloadItem.h"

ResourceService* globalResourceService;

@implementation ResourceService

+ (ResourceService*)defaultService
{
    if (globalResourceService == nil)
        globalResourceService = [[ResourceService alloc] init];
    return globalResourceService;
}

- (void)findAllTopDownloadItems:(id<ResourceServiceDelegate>)delegateObject requestType:(int)requestType
{
    NSString* appId = @"";
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;  
        
        output = [DownloadNetworkRequest findAllTopDownloadItems:SERVER_URL 
                                                appId:appId 
                                          countryCode:[LocaleUtils getCountryCode]];
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // save data locally
            NSArray* itemList;
            if (output.resultCode == 0){
                itemList = [[TopDownloadManager defaultManager] updateData:output.jsonDataArray];
            }
            
            // notify UI to refresh data
            NSLog(@"<findAllTopDownloadItems> result code=%d, get total %d items", 
                  output.resultCode, [output.jsonDataArray count]);
            
            if ([delegateObject respondsToSelector:@selector(findAllSitesFinish:requestType:newDataList:)]){
                [delegateObject findAllSitesFinish:output.resultCode
                                       requestType:requestType newDataList:itemList];
            }
        });
        
        
    });    

}

- (void)findAllSites:(id<ResourceServiceDelegate>)delegateObject requestType:(int)requestType
{
    NSString* appId = @"";
    
    NSNumber* sortBy = nil;
    NSNumber* type = nil;
    
    switch (requestType) {
        case SITE_REQUEST_TYPE_TOP:
            sortBy = [NSNumber numberWithInt:SORT_BY_DOWNLOAD];
            break;
            
        case SITE_REQUEST_TYPE_HOT:
            type = [NSNumber numberWithInt:SITE_TYPE_SYSTEM];
            break;
            
        case SITE_REQUEST_TYPE_NEW:
            sortBy = [NSNumber numberWithInt:SORT_BY_START_DATE];
            break;
            
        default:
            break;
    }
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;        
        output = [DownloadNetworkRequest findAllSites:SERVER_URL 
                                                appId:appId 
                                          countryCode:[LocaleUtils getCountryCode]
                                                 type:type
                                               sortBy:sortBy];
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // save data locally
            NSArray* siteList;
            if (output.resultCode == 0){
                siteList = [[TopSiteManager defaultManager] updateData:output.jsonDataArray];
            }
            
            // notify UI to refresh data
            NSLog(@"<findAllSites> result code=%d, get total %d sites", 
                  output.resultCode, [output.jsonDataArray count]);
            
            if ([delegateObject respondsToSelector:@selector(findAllSitesFinish:requestType:newDataList:)]){
                [delegateObject findAllSitesFinish:output.resultCode
                 requestType:requestType newDataList:siteList];
            }
        });
        
        
    });    
}


@end
