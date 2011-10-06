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
#import "TimeUtils.h"
#import "GroupBuyNetworkConstants.h"
#import "ProductManager.h"
#import "CategoryManager.h"

@implementation UserShopItemService

@synthesize userShopItemServiceDelegate;

+ (NSString*)generateItemId
{
    return [NSString stringWithInt:time(0)];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)refreshUserShoppingItemMatchCount:(NSArray *)itemIds appId:(NSString *)appId userId:(NSString *)userId
{
            
    if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didBeginLoadMatchCount:)]) {
        [self.userShopItemServiceDelegate didBeginLoadMatchCount:itemIds];
    }

    dispatch_async(workingQueue, ^{
        CommonNetworkOutput* countOutput = nil;
        countOutput =[GroupBuyNetworkRequest getUserShoppingItemCount:SERVER_URL appId:appId userId:userId itemIdArray:itemIds requiredMatch:YES];
        
       dispatch_async(dispatch_get_main_queue(), ^{
           
            if (countOutput.resultCode == ERROR_SUCCESS) {
                NSArray* itemArray = countOutput.jsonDataArray;
                if (itemArray != nil && [itemArray count] > 0) {
                    for (NSDictionary* itemDict in itemArray){
                        NSNumber *cnt = [itemDict objectForKey:PARA_MATCHITEMCOUNT];
                        NSString *itemId = [itemDict objectForKey:PARA_ITEMID];
                        if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didLoadMatchCountSuccess:matchCount:)]) {
                            [self.userShopItemServiceDelegate didLoadMatchCountSuccess:itemId matchCount:cnt];
                        }
                    }   
                }else{
                    for (NSString *itemId in itemIds) {              
                        if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didLoadMatchCountSuccess:matchCount:)]) {
                        [self.userShopItemServiceDelegate didLoadMatchCountSuccess:itemId matchCount:nil];
                        }
                    }
                }
            }else {
                if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didLoadMatchCountFailed:errorCode:)]) {
                    [self.userShopItemServiceDelegate didLoadMatchCountFailed:itemIds errorCode:countOutput.resultCode];
                }
            }
           
           if ([self.userShopItemServiceDelegate respondsToSelector:@selector(refreshShoppingList)]) {
               [self.userShopItemServiceDelegate refreshShoppingList];
           }
           
        });

    });

}

- (void)addUserShoppingItem:(NSString*)city
               categoryName:(NSString*)categoryName
              subCategories:(NSArray*)subCategories
                   keywords:(NSString*)keywords
                   maxPrice:(NSNumber*)maxPrice
                 expireDate:(NSDate*)expireDate 
                   latitude:(NSNumber *)latitude 
                  longitude:(NSNumber *)longitude 
                     radius:(NSNumber *)radius
                     rebate:(NSNumber *)rebate
{

    NSString *itemId = [UserShopItemService generateItemId];
    
    //userid appid
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    //category
    
    //subcategory
    NSString *subCategoryNames = nil;
    if (subCategories != nil ) {
        subCategoryNames = [UserShopItemManager getSubCategoryNameWithArray:subCategories];
        subCategoryNames = [CategoryManager refineSubCategoryNames:categoryName 
                                                  subCategoryNames:subCategoryNames];
    }
    
    //expire date
    NSString *dateString = dateToUTCStringByFormat(expireDate, @"yyyyMMddHHmmss");
    
    if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didBeginUpdateShoppingItem:)]) {
        [self.userShopItemServiceDelegate didBeginUpdateShoppingItem:@"更新数据中......"];
    }
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        output = [GroupBuyNetworkRequest addUserShoppingItem:SERVER_URL appId:appId userId:userId itemId:itemId city:city categoryName:categoryName subCategoryName:subCategoryNames keywords:keywords expireDate:dateString maxPrice:maxPrice latitude:latitude longitude:longitude radius:radius minRebate:nil];
        
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{

            if (output.resultCode == ERROR_SUCCESS) {
                [UserShopItemManager createShoppingItem:itemId city:city categoryName:categoryName subCategoryName:subCategoryNames keywords:keywords maxPrice:maxPrice expireDate:expireDate latitude:latitude longitude:longitude radius:radius];
                }
        
            //update ui
            if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didEndUpdateShoppingItemWithResultCode:)]) {
                [self.userShopItemServiceDelegate didEndUpdateShoppingItemWithResultCode:output.resultCode];
            }
            
            if (output.resultCode == ERROR_SUCCESS) {
                //get count
                NSArray *itemIds = [NSArray arrayWithObject:itemId];
                    [self refreshUserShoppingItemMatchCount:itemIds appId:appId userId:userId];
            }
            

    });
    });
              
}

- (void)updateUserShoppingItem:(NSString *)itemId 
                          city:(NSString*)city
                  categoryName:(NSString*)categoryName
                 subCategories:(NSArray*)subCategories
                      keywords:(NSString*)keywords
                      maxPrice:(NSNumber*)maxPrice
                    expireDate:(NSDate*)expireDate 
                      latitude:(NSNumber *)latitude 
                     longitude:(NSNumber *)longitude 
                        radius:(NSNumber *)radius
                        rebate:(NSNumber *)rebate
{
    [ProductManager deleteProductsByUseFor:[itemId intValue]];
    
    //userid appid
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    //category
    
    //subcategory
    NSString *subCategoryNames = nil;
    if (subCategories != nil ) {
        subCategoryNames = [UserShopItemManager getSubCategoryNameWithArray:subCategories];
        subCategoryNames = [CategoryManager refineSubCategoryNames:categoryName 
                                                  subCategoryNames:subCategoryNames];
    }
    
    //expire date
    NSString *dateString = dateToUTCStringByFormat(expireDate, @"yyyyMMddHHmmss");
    
    if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didBeginUpdateShoppingItem:)]) {
        [self.userShopItemServiceDelegate didBeginUpdateShoppingItem:@"更新数据中......"];
    }
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        output = [GroupBuyNetworkRequest updateUserShoppingItem:SERVER_URL appId:appId userId:userId itemId:itemId city:city categoryName:categoryName subCategoryName:subCategoryNames keywords:keywords expireDate:dateString maxPrice:maxPrice latitude:latitude longitude:longitude radius:radius minRebate:nil];
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (output.resultCode == ERROR_SUCCESS) {
                [UserShopItemManager createShoppingItem:itemId city:city categoryName:categoryName subCategoryName:subCategoryNames keywords:keywords maxPrice:maxPrice expireDate:expireDate latitude:latitude longitude:longitude radius:radius];
            }
            //update ui
            if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didEndUpdateShoppingItemWithResultCode:)]) {
                [self.userShopItemServiceDelegate didEndUpdateShoppingItemWithResultCode:output.resultCode];
            }
             if (output.resultCode == ERROR_SUCCESS) {
                //get match count
                NSArray *itemIds = [NSArray arrayWithObject:itemId];
                [self refreshUserShoppingItemMatchCount:itemIds appId:appId userId:userId];
             }
        });
    });
}


- (void)requestItemMatchCount:(NSString*)itemId
{
    if (itemId == nil || [itemId length] == 0){
        NSLog(@"<requestItemMatchCount> but itemId is nil or empty");
        return;
    }    
    
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    NSArray *itemIds = [NSArray arrayWithObject:itemId];
    [self refreshUserShoppingItemMatchCount:itemIds appId:appId userId:userId];
    
}


- (void)deleteUserShoppingItem:(NSString*)itemId
{
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didBeginDeleteItem:)]) {
        [self.userShopItemServiceDelegate didBeginDeleteItem:@"删除数据中......"];
    }
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output =[GroupBuyNetworkRequest deleteUserShoppingItem:SERVER_URL appId:appId userId:userId itemId:itemId];
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (output.resultCode == ERROR_SUCCESS){
                // save data locally
                [UserShopItemManager removeItemForItemId:itemId];
                [ProductManager deleteProductsByUseFor:[itemId intValue]];
            }
            if ([self.userShopItemServiceDelegate respondsToSelector:@selector(didEndDeleteItem:Code:)]) {
                [self.userShopItemServiceDelegate didEndDeleteItem:itemId Code:output.resultCode];
            }

        });
        
        
    });  

}

- (void)updateUserShoppingItemCountList
{
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    NSArray *itemIds = [UserShopItemManager getAllLocalShoppingItemIds];
    
    [self refreshUserShoppingItemMatchCount:itemIds appId:appId userId:userId];
}

@end
