//
//  UserShopItemService.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupBuyNetworkConstants.h"
#import "GroupBuyNetworkRequest.h"
#import "PPNetworkRequest.h"
#import "UserShopItemService.h"
#import "UserService.h"
#import "AppManager.h"

@implementation UserShopItemService

@synthesize delegate;

- (void)dealloc
{
    [super dealloc];
}

- (void)addUserShoppingItem:(NSString*)itemId
                                       city:(NSString*)city
                               categoryName:(NSString*)categoryName
                            subCategoryName:(NSString*)subCategoryName
                                   keywords:(NSString*)keywords
                                   maxPrice:(NSNumber*)maxPrice
                                  minRebate:(NSNumber*)minRebate
{
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest addUserShoppingItem:SERVER_URL appId:appId userId:userId itemId:itemId city:city categoryName:categoryName subCategoryName:subCategoryName keywords:keywords maxPrice:maxPrice minRebate:minRebate];
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // notify UI to refresh data
//            NSLog(@"<requestProductData> result code=%d, get total %d product", 
//                  output.resultCode, [output.jsonDataArray count]);
            
            if ([delegate respondsToSelector:@selector(itemActionDone:)]){
                [delegate itemActionDone:output.resultCode];
            }
        });
        
        
    });    
}

@end
