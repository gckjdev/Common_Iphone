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
#import "UserShopItemManager.h"
#import "UserService.h"
#import "AppManager.h"
#import "StringUtil.h"

@implementation UserShopItemService

@synthesize delegate;

+ (NSString*)generateItemId
{
    return [NSString GetUUID];
}

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
                                  expireDate:(NSDate*)expireDate
{
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    if (itemId == nil){
        itemId = [UserShopItemService generateItemId];
    }
    
    [UserShopItemManager createShoppingItem:itemId city:city categoryName:categoryName
                            subCategoryName:subCategoryName keywords:keywords
                                   maxPrice:maxPrice expireDate:expireDate];
    
//    dispatch_async(workingQueue, ^{
//        
//        // fetch user place data from server
//        CommonNetworkOutput* output = nil;
//        
//        output = [GroupBuyNetworkRequest addUserShoppingItem:SERVER_URL appId:appId userId:userId itemId:itemId city:city categoryName:categoryName subCategoryName:subCategoryName keywords:keywords maxPrice:maxPrice minRebate:nil];
//        
//        // if succeed, clean local data and save new data
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            if (output.resultCode == ERROR_SUCCESS){
//                // save data locally
//                [UserShopItemManager createShoppingItem:itemId city:city categoryName:categoryName
//                                        subCategoryName:subCategoryName keywords:keywords
//                                               maxPrice:maxPrice expireDate:expireDate];
//            }
//            
//            // notify UI to refresh data
//            if ([delegate respondsToSelector:@selector(itemActionDone:)]){
//                [delegate itemActionDone:output.resultCode];
//            }
//        });
//        
//        
//    });    
}

@end
