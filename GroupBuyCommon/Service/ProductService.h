//
//  ProductService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

#define PRODUCT_ACTION_CLICK    @"Click"
#define PRODUCT_ACTION_BUY      @"Buy"
#define PRODUCT_ACTION_ADD_FAVORITE @"Favor"
#define PRODUCT_ACTION_FORWARD  @"Send"

@protocol ProductServiceDelegate <NSObject>

@optional

// common method now!!! we can refactor all to this method 
- (void)productDataRefresh:(int)result;
- (void)productDataRefresh:(int)result jsonArray:(NSArray*)jsonArray;

@end

@interface ProductService : CommonService {
    
    dispatch_queue_t    actionWorkingQueue;
}

- (void)requestProductData:(id<ProductServiceDelegate>)delegateObject
                    useFor:(int)useFor
               startOffset:(int)startOffset
                 cleanData:(BOOL)cleanData;

- (void)requestProductData:(id<ProductServiceDelegate>)delegateObject
                    useFor:(int)useFor
               startOffset:(int)startOffset
                 cleanData:(BOOL)cleanData
				   keyword:(NSString*)keyword;

- (void)requestProductDataByCategory:(id<ProductServiceDelegate>)delegateObject todayOnly:(BOOL)todayOnly;

- (void)updateKeywords;

- (void)actionOnProduct:(NSString*)productId actionName:(NSString*)actionName actionValue:(int)actionValue;

@end

extern ProductService* GlobalGetProductService();