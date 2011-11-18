//
//  CategoryService.m
//  groupbuy
//
//  Created by  on 11-9-18.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CategoryService.h"
#import "AppManager.h"
#import "GroupBuyNetworkRequest.h"
#import "GroupBuyNetworkConstants.h"
#import "PPNetworkRequest.h"
#import "LocationService.h"

@implementation CategoryService

- (void)getAllCategory:(id<CategoryServiceDelegate>)delegate categoryType:(int)categoryType
{
    NSString* appId = [AppManager getPlaceAppId];
    NSString* city = [GlobalGetLocationService() getDefaultCity];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput *output = nil;
        
        output = [GroupBuyNetworkRequest getAllCategory:SERVER_URL appId:appId city:city categoryType:categoryType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // notify UI to refresh data
            NSLog(@"<getAllCategory> result code=%d, data=%@", 
                  output.resultCode, output.jsonDataArray);
            
            if ([delegate respondsToSelector:@selector(getAllCategoryFinish:jsonArray:)]) {
                [delegate getAllCategoryFinish:output.resultCode jsonArray:output.jsonDataArray];
            }
        });
    });
}

- (void)getAllCategory:(id<CategoryServiceDelegate>)delegate
{
    return [self getAllCategory:delegate categoryType:DATA_UNDEFINE];
}

@end
