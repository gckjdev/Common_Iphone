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
        CommonNetworkOutput* output = [GroupBuyNetworkRequest findAllProductsWithPrice:SERVER_URL appId:appId startOffset:startOffset city:city];
                                               
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


@end