//
//  ProductService.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductService.h"
#import "AppManager.h"
#import "ProductManager.h"
#import "Product.h"
#import "PPNetworkRequest.h"
#import "GroupBuyNetworkRequest.h"
#import "GroupBuyNetworkConstants.h"
#import "LocationService.h"
#import "HotKeywordManager.h"
#import "GroupBuyUserService.h"

@implementation ProductService

- (void)notifyDelegate:(id)delegate selector:(SEL)selector resultCode:(int)resultCode
{
    if (delegate != nil && [delegate respondsToSelector:selector]){
        
        NSMethodSignature *sig = [delegate methodSignatureForSelector:selector];
        if (sig){
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
            [inv setSelector:selector];
            [inv setTarget:delegate];
            [inv setArgument:&resultCode atIndex:2]; //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
            [inv invoke];        
        }
    }
}

- (void)requestProductData:(id<ProductServiceDelegate>)delegateObject
                    useFor:(int)useFor
               startOffset:(int)startOffset
                 cleanData:(BOOL)cleanData
{
	[self requestProductData:delegateObject useFor:useFor startOffset:startOffset cleanData:cleanData keyword:nil];
}
	

- (void)requestProductData:(id<ProductServiceDelegate>)delegateObject
                    useFor:(int)useFor
               startOffset:(int)startOffset
                 cleanData:(BOOL)cleanData
				   keyword:(NSString*)keyword

{    
//    NSString* userId = [UserManager getUserId];
    
    //LocationService *service =  GlobalGetLocationService();
    LocationService *locationService =GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];

    NSString* appId = [AppManager getPlaceAppId];
    NSString* city = [GlobalGetLocationService() getDefaultCity]; // need to get from LocationService    
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        switch (useFor) {
            case USE_FOR_BOUGHT:
                output = [GroupBuyNetworkRequest findAllProductsWithBought:SERVER_URL 
                                                                    appId:appId 
                                                              startOffset:startOffset 
                                                                     city:city];                
                break;
                
            case USE_FOR_REBATE:
                output = [GroupBuyNetworkRequest findAllProductsWithRebate:SERVER_URL 
                                                                    appId:appId 
                                                              startOffset:startOffset 
                                                                     city:city];
                break;
                
            case USE_FOR_PRICE:
                output = [GroupBuyNetworkRequest findAllProductsWithPrice:SERVER_URL 
                                                                    appId:appId 
                                                              startOffset:startOffset 
                                                                     city:city];
                break;
				
			case USE_FOR_KEYWORD:
                output = [GroupBuyNetworkRequest findAllProductsByKeyword:SERVER_URL
                                                                    appId:appId
                                                                     city:city
																  keyword:keyword
                                                              startOffset:startOffset];
                break;
				
            case USE_FOR_DISTANCE:
            {
                double latitude = location.coordinate.latitude;
                double longitude = location.coordinate.longitude;
                output = [GroupBuyNetworkRequest findAllProductsWithLocation:SERVER_URL 
                                                                    appId:appId
                                                                        city:city
                                                                    latitude:latitude
                                                                   longitude:longitude 
                                                              startOffset:startOffset];
            }
                break;
            case USE_FOR_TOPSCORE_BELOW_TEN:
            {
                output = [GroupBuyNetworkRequest findAllProductsByScore:SERVER_URL appId:appId startOffset:startOffset city:city startPrice:-10 endPrice:10];
            }
                break;
                
            case USE_FOR_TOPSCORE_ABOVE_TEN:
            {
                output = [GroupBuyNetworkRequest findAllProductsByScore:SERVER_URL appId:appId startOffset:startOffset city:city startPrice:10 endPrice:1000000];
            }
                break;
                
            case USE_FOR_STARTDATE:
            {
                output = [GroupBuyNetworkRequest findAllProductsWithStartDate:SERVER_URL appId:appId startOffset:startOffset city:city];
            }
                break;
                
            default:
            {
                if (useFor >= USE_FOR_PER_CATEGORY && useFor < USE_FOR_PER_SHOPPINGITEM){
                    NSString* categoryId = [NSString stringWithFormat:@"%d", (useFor - USE_FOR_PER_CATEGORY)];
                    output = [GroupBuyNetworkRequest findProducts:SERVER_URL appId:appId city:city hasLocation:NO longitude:0.0 latitude:0.0 maxDistance:DEFAULT_MAX_DISTANCE todayOnly:NO category:categoryId sortBy:SORT_BY_START_DATE startOffset:startOffset maxCount:DEFAULT_MAX_COUNT];
                }else if(useFor > USE_FOR_PER_SHOPPINGITEM)
                {
                    NSString* userId = [GlobalGetUserService() userId];
                    NSString* itemId = [NSString stringWithFormat:@"%d",useFor];
                    output = [GroupBuyNetworkRequest getShoppingItemProducts:SERVER_URL userId:userId appId:appId itemId:itemId startOffset:startOffset maxCount:DEFAULT_MAX_COUNT];
                }
                
                
            }
                break;
        }
                                               
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            if (output.resultCode == ERROR_SUCCESS){                    
                // delete all old data
                if (cleanData){
                    [ProductManager deleteProductsByUseFor:useFor];
                }
                
                // insert new data
                NSArray* productArray = output.jsonDataArray;
                int offset = startOffset;
                for (NSDictionary* productDict in productArray){
                    [ProductManager createProduct:productDict useFor:useFor 
                                           offset:offset currentLocation:location];
                    offset ++;
                }                    
            }
            
            // notify UI to refresh data
            NSLog(@"<requestProductData> result code=%d, get total %d product", 
                  output.resultCode, [output.jsonDataArray count]);
            
            [self notifyDelegate:delegateObject selector:@selector(productDataRefresh:) resultCode:output.resultCode];

            
        });
        
        
    });
    
}

- (void)requestProductDataByCategory:(id<ProductServiceDelegate>)delegateObject todayOnly:(BOOL)todayOnly
{
    NSString* appId = [AppManager getPlaceAppId];
    NSString* city = [GlobalGetLocationService() getDefaultCity]; // need to get from LocationService    
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest findAllProductsGroupByCategory:SERVER_URL appId:appId city:city todayOnly:todayOnly];
        
        // if succeed, clean local data and save new data
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // notify UI to refresh data
            NSLog(@"<requestProductData> result code=%d, get total %d product", 
                  output.resultCode, [output.jsonDataArray count]);
            
            if ([delegateObject respondsToSelector:@selector(productDataRefresh:jsonArray:)]){
                [delegateObject productDataRefresh:output.resultCode jsonArray:output.jsonDataArray];
            }
        });
        
        
    });    
}

- (void)updateKeywords
{
    NSString* appId = [AppManager getPlaceAppId];

    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest updateKeywords:SERVER_URL appId:appId];
        
        // if succeed, clean local data and save new data
        if (output.resultCode == ERROR_SUCCESS){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"<appUpdate> result code=%d, get total %d keywords", 
                      output.resultCode, [output.jsonDataArray count]);
                
                // save data
                [HotKeywordManager createHotKeywords:output.jsonDataArray];                
            });
        }
        
        
    });      
}

- (void)actionOnProduct:(NSString*)productId actionName:(NSString*)actionName actionValue:(int)actionValue
{
    if (actionWorkingQueue == NULL){
        actionWorkingQueue = dispatch_queue_create("action queue", NULL);
    }
    
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    LocationService *locationService =GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];
    BOOL hasLocation = NO;
    if (location != nil)
        hasLocation = YES;
    
    // TODO, cache request in 3G network    
    
    dispatch_async(actionWorkingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest actionOnProduct:SERVER_URL appId:appId userId:userId productId:productId actionName:actionName actionValue:actionValue hasLocation:hasLocation latitude:location.coordinate.latitude longitude:location.coordinate.longitude];        
    });      
}

- (void)actionOnProduct:(NSString*)productId actionName:(NSString*)actionName actionValue:(int)actionValue viewController:(PPViewController<ProductServiceDelegate>*)viewController
{
    if (actionWorkingQueue == NULL){
        actionWorkingQueue = dispatch_queue_create("action queue", NULL);
    }
    
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    LocationService *locationService =GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];
    BOOL hasLocation = NO;
    if (location != nil)
        hasLocation = YES;
    
    // TODO, cache request in 3G network    
    [viewController showActivityWithText:@"发送请求中..."];
    dispatch_async(actionWorkingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest actionOnProduct:SERVER_URL appId:appId userId:userId productId:productId actionName:actionName actionValue:actionValue hasLocation:hasLocation latitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // update post action value in DB
            }
            else if (output.resultCode == ERROR_NETWORK){
                [viewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else{
                [viewController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
            }
            
            if ([viewController respondsToSelector:@selector(actionOnProductFinish:actionName:count:)]){
                long count = [[output.jsonDataDict objectForKey:actionName] longValue];
                [viewController actionOnProductFinish:output.resultCode actionName:actionName count:count];
            }
        });
    });
}

- (void)writeCommentWithContent:(NSString *)content nickName:(NSString *)nickName productId:(NSString *)productId viewController:(PPViewController<ProductServiceDelegate>*)viewController
{
    if (actionWorkingQueue == NULL){
        actionWorkingQueue = dispatch_queue_create("action queue", NULL);
    }
    
    NSString* userId = [GlobalGetUserService() userId];
    NSString* appId = [AppManager getPlaceAppId];
    LocationService *locationService =GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];
    BOOL hasLocation = NO;
    if (location != nil)
        hasLocation = YES;
    
    // TODO, cache request in 3G network    
    [viewController showActivityWithText:@"提交评论中..."];
    dispatch_async(actionWorkingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest writeCommentWithContent:content nickName:nickName appId:appId userId:userId productId:productId hasLocation:hasLocation latitude:location.coordinate.latitude longitude:location.coordinate.longitude baseURL:SERVER_URL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // update post action value in DB
            }
            else if (output.resultCode == ERROR_NETWORK){
                [viewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else{
                [viewController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
            }
            
            if ([viewController respondsToSelector:@selector(writeCommentFinish:)]){
                [viewController writeCommentFinish:output.resultCode];
            }
        });
    });
}

- (void)getCommentsWithProductId:(NSString *)productId viewController:(PPViewController<ProductServiceDelegate>*)viewController
{
    if (actionWorkingQueue == NULL){
        actionWorkingQueue = dispatch_queue_create("action queue", NULL);
    }
    
    NSString* appId = [AppManager getPlaceAppId];
    
    [viewController showActivityWithText:@"正在获取评论中..."];
    dispatch_async(actionWorkingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest getCommentsWithProductId:productId appId:appId baseURL:SERVER_URL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController hideActivity];
            if (output.resultCode == ERROR_SUCCESS){               
                // update post action value in DB
            }
            else if (output.resultCode == ERROR_NETWORK){
                [viewController popupUnhappyMessage:NSLS(@"kSystemFailure") title:nil];
            }
            else{
                [viewController popupUnhappyMessage:NSLS(@"kUnknowFailure") title:nil];
            }
            
            if ([viewController respondsToSelector:@selector(getCommentFinish:jsonArray:)]){
                [viewController getCommentFinish:output.resultCode jsonArray:output.jsonDataArray];
            }
        });
    });
}

@end
