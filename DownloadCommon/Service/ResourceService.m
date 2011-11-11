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

ResourceService* globalResourceService;

@implementation ResourceService

+ (ResourceService*)defaultService
{
    if (globalResourceService == nil)
        globalResourceService = [[ResourceService alloc] init];
    return globalResourceService;
}

- (void)findAllSites:(id<ResourceServiceDelegate>)delegateObject
{
    NSString* appId = @"";
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;        
        output = [DownloadNetworkRequest findAllSites:SERVER_URL 
                                                appId:appId 
                                          countryCode:[LocaleUtils getCountryCode]];
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // save data locally
            if (output.resultCode == 0){
                [[TopSiteManager defaultManager] updateData:output.jsonDataArray];
            }
            
            // notify UI to refresh data
            NSLog(@"<findAllSites> result code=%d, get total %d sites", 
                  output.resultCode, [output.jsonDataArray count]);
            
            if ([delegateObject respondsToSelector:@selector(findAllSitesFinish:)]){
                [delegateObject findAllSitesFinish:output.resultCode];
            }
        });
        
        
    });    
}


@end
