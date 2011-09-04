//
//  ProductPriceDataLoader.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonProductListController.h"

@interface ProductPriceDataLoader : NSObject<ProductDataLoader> {
    
    
}

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end

@interface ProductRebateDataLoader : NSObject<ProductDataLoader> {
    
    
}

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end

@interface ProductDistanceDataLoader : NSObject<ProductDataLoader> {
    
    
}

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end

@interface ProductBoughtDataLoader : NSObject<ProductDataLoader> {
    
    
}

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end

@interface ProductHistoryDataLoader : NSObject<ProductDataLoader> {
    
    
}

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end


@interface ProductFavoriteDataLoader : NSObject<ProductDataLoader> {
    
    
}

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end

@interface ProductCategoryDataLoader : NSObject<ProductDataLoader> {
    
    NSString    *categoryId;
    
}
@property (nonatomic, retain)     NSString    *categoryId;

- (id)initWithCategoryId:(NSString*)categoryId;
- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end

@interface ProductShoppingItemDataLoader : NSObject<ProductDataLoader> {
    
    NSString    *shoppingItemId;
    
}
@property (nonatomic, retain)     NSString    *shoppingItemId;

- (id)initWithShoppingItemId:(NSString*)itemId;
- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end


@interface ProductKeywordDataLoader : NSObject<ProductDataLoader> {
    NSString    *keyword;
}

@property (nonatomic, retain)     NSString    *keyword;

- (id)initWithKeyword:(NSString*)keyword;
- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

@end
