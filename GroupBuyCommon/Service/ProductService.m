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
//    NSString* userId = [UserManager getUserId];
    NSString* appId = [AppManager getPlaceAppId];
    NSString* city = @"北京"; // need to get from LocationService    
    
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
            
            case USE_FOR_DISTANCE:
            {
                //LocationService *service =  GlobalGetLocationService();
                LocationService *locationService =GlobalGetLocationService();
                CLLocation *location = [locationService currentLocation];
                double latitude = location.coordinate.latitude;
                double longitude = location.coordinate.longitude;
                output = [GroupBuyNetworkRequest findAllProductsWithLocation:SERVER_URL 
                                                                    appId:appId
                                                                    latitude:latitude
                                                                   longitude:longitude 
                                                              startOffset:startOffset];
            }
                break;
                
            default:
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
                for (NSDictionary* productDict in productArray){
                    [ProductManager createProduct:productDict useFor:useFor];
                }                    
            }
            
            // notify UI to refresh data
            NSLog(@"<requestProductData> result code=%d, get total %d product", 
                  output.resultCode, [output.jsonDataArray count]);
            
            [self notifyDelegate:delegateObject selector:@selector(productDataRefresh:) resultCode:output.resultCode];

            
        });
        
        
    });
    
}

- (void)requestProductDataByCategory:(id<ProductServiceDelegate>)delegateObject
{
    NSString* appId = [AppManager getPlaceAppId];
    NSString* city = @"北京"; // need to get from LocationService    
    
    dispatch_async(workingQueue, ^{
        
        // fetch user place data from server
        CommonNetworkOutput* output = nil;
        
        output = [GroupBuyNetworkRequest findAllProductsGroupByCategory:SERVER_URL appId:appId city:city];
        
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

@end
