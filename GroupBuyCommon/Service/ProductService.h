//
//  ProductService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@protocol ProductServiceDelegate <NSObject>

@optional

// common method now!!! we can refactor all to this method 
- (void)productDataRefresh:(int)result;
- (void)productDataRefresh:(int)result jsonArray:(NSArray*)jsonArray;

@end

@interface ProductService : CommonService {
    
}

- (void)requestProductData:(id<ProductServiceDelegate>)delegateObject
                    useFor:(int)useFor
               startOffset:(int)startOffset
                 cleanData:(BOOL)cleanData;

- (void)requestProductDataByCategory:(id<ProductServiceDelegate>)delegateObject todayOnly:(BOOL)todayOnly;
@end

extern ProductService* GlobalGetProductService();