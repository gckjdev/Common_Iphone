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
#import "ShoppingListController.h"
#import "AddShoppingItemController.h"
@implementation UserShopItemService

@synthesize delegate;

+ (NSString*)generateItemId
{
    return [NSString stringWithInt:time(0)];
}

- (void)dealloc
{
    [super dealloc];
}
- (void)addUserShoppingItem:(NSString *)city categoryName:(NSString *)categoryName subCategories:(NSArray *)subCategories keywords:(NSString *)keywords maxPrice:(NSNumber *)maxPrice expireDate:(NSDate *)expireDate rebate:(NSNumber *)rebate viewController:(AddShoppingItemController *)viewController  
{
    NSString *itemId = [UserShopItemService generateItemId];
    [self handleUserShoppingItem:itemId city:city categoryName:categoryName subCategories:subCategories keywords:keywords maxPrice:maxPrice expireDate:expireDate rebate:rebate viewController:viewController handleType:CreateShoppingItem];
}

- (void)updateUserShoppingItem:(NSString *)itemId city:(NSString *)city categoryName:(NSString *)categoryName subCategories:(NSArray *)subCategories keywords:(NSString *)keywords maxPrice:(NSNumber *)maxPrice expireDate:(NSDate *)expireDate rebate:(NSNumber *)rebate viewController:(AddShoppingItemController *)viewController
{
    
        [ProductManager deleteProductsByUseFor:[itemId intValue]];
        [self handleUserShoppingItem:itemId city:city categoryName:categoryName subCategories:subCategories keywords:keywords maxPrice:maxPrice expireDate:expireDate rebate:rebate viewController:viewController handleType:UpdateShoppingItem];
}

- (void)handleUserShoppingItem:(NSString*)itemId
                          city:(NSString*)city
                  categoryName:(NSString*)categoryName
                 subCategories:(NSArray*)subCategories
                      keywords:(NSString*)keywords
                      maxPrice:(NSNumber*)maxPrice
                    expireDate:(NSDate*)expireDate 
                        rebate:(NSNumber *)rebate 
                viewController:(AddShoppingItemController *)viewController 
                    handleType:(ShoppingItemHandleType)handleType
{
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    NSString *subCategoryNames = nil;
    if (subCategories != nil ) {
        subCategoryNames = [UserShopItemManager getSubCategoryNameWithArray:subCategories];
    }
    
    NSString *dateString = dateToUTCStringByFormat(expireDate, @"yyyyMMddHHmmss");
    
    [viewController showActivityWithText:@"服务器处理数据中......"];
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        if (handleType == CreateShoppingItem) {
            output = [GroupBuyNetworkRequest addUserShoppingItem:SERVER_URL appId:appId userId:userId itemId:itemId city:city categoryName:categoryName subCategoryName:subCategoryNames keywords:keywords expireDate:dateString maxPrice:maxPrice minRebate:rebate];
        }else if(handleType == UpdateShoppingItem){
            output = [GroupBuyNetworkRequest updateUserShoppingItem:SERVER_URL appId:appId userId:userId itemId:itemId city:city categoryName:categoryName subCategoryName:subCategoryNames keywords:keywords expireDate:dateString maxPrice:maxPrice minRebate:rebate];
        }
        
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){
                // save data locally
                [UserShopItemManager createShoppingItem:itemId city:city categoryName:categoryName subCategoryName:subCategoryNames keywords:keywords maxPrice:maxPrice expireDate:expireDate];
                ShoppingListController *tableViewController = viewController.shoppingListTableViewController;
                
                [viewController.navigationController popViewControllerAnimated:YES];
                
                
                dispatch_async(workingQueue, ^{
                    CommonNetworkOutput* countOutput = nil;
                    
                    countOutput =[GroupBuyNetworkRequest getUserShoppingItemCount:SERVER_URL appId:appId userId:userId itemIdArray:[NSArray arrayWithObject:itemId] requiredMatch:YES];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (countOutput.resultCode == ERROR_SUCCESS) {
                            NSArray* itemArray = countOutput.jsonDataArray;
                            if (itemArray != nil && [itemArray count] > 0) {
                                for (NSDictionary* itemDict in itemArray){
                                    NSNumber *cnt = [itemDict objectForKey:PARA_MATCHITEMCOUNT];
                                    NSString *itemId = [itemDict objectForKey:PARA_ITEMID];
                                    [UserShopItemManager updateItemMatchCount:cnt itemId:itemId];
                                }   
                            }else {
                                [UserShopItemManager updateItemMatchCountStatus:ShoppingItemCountOld itemId:itemId];
                            }
                        }else {
                            [UserShopItemManager updateItemMatchCountStatus:ShoppingItemCountOld itemId:itemId];
                        }  
                        tableViewController.dataList = [UserShopItemManager getAllLocalShoppingItems];
                        [tableViewController.dataTableView reloadData];
                        
                    });
                    
                });
                
                
            }else if (output.resultCode == ERROR_NETWORK){
                [viewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else{
                [viewController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
            }
            
            //            // notify UI to refresh data
            //            if ([delegate respondsToSelector:@selector(itemActionDone:)]){
            //                [delegate itemActionDone:output.resultCode];
            //            }
        });
        
    });    
    
}


- (void)deleteUserShoppingItem:(NSString*)itemId viewController:(PPTableViewController *)tableViewController indexPath:(NSIndexPath *)indexPath{
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    [tableViewController showActivityWithText:@"删除数据中......"];
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
                
                tableViewController.dataList = [UserShopItemManager getAllLocalShoppingItems];
                [tableViewController.dataTableView beginUpdates];        
                [tableViewController.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableViewController.dataTableView endUpdates];
                
            }else if (output.resultCode == ERROR_NETWORK){
                [tableViewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else{
                [tableViewController popupUnhappyMessage:@"对不起，删除不成功" title:nil];
            }
            
            [tableViewController hideActivity];
            //            
            //            // notify UI to refresh data
            //            if ([delegate respondsToSelector:@selector(itemActionDone:)]){
            //                [delegate itemActionDone:output.resultCode];
            //            }
        });
        
        
    });  
}

- (void)updateUserShoppingItemCountList:(PPTableViewController *)tableViewController
{
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    
    [tableViewController showActivityWithText:@"正在更新数据......"];
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output =[GroupBuyNetworkRequest getUserShoppingItemCount:SERVER_URL appId:appId userId:userId itemIdArray:nil requiredMatch:NO];
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (output.resultCode == ERROR_SUCCESS){
                
                //deal with the output && update db
                
                NSArray* itemArray = output.jsonDataArray;
                
                for (NSDictionary* itemDict in itemArray){
                    NSNumber *cnt = [itemDict objectForKey:PARA_MATCHITEMCOUNT];
                    NSString *itemId = [itemDict objectForKey:PARA_ITEMID];
                    [UserShopItemManager updateItemMatchCount:cnt itemId:itemId];
                }     
                
                //refresh datalist
                tableViewController.dataList = [UserShopItemManager getAllLocalShoppingItems];
                [tableViewController.dataTableView reloadData];
                
            }else if (output.resultCode == ERROR_NETWORK){
                [tableViewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else{
                [tableViewController popupUnhappyMessage:@"对不起，获取数据不成功" title:nil];
            }
            
            [tableViewController hideActivity];
            //            
            //            // notify UI to refresh data
            //            if ([delegate respondsToSelector:@selector(itemActionDone:)]){
            //                [delegate itemActionDone:output.resultCode];
            //            }
        });
        
        
    });  
}

@end
