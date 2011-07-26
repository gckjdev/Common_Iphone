//
//  ProductPriceDataLoader.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductPriceDataLoader.h"
#import "ProductManager.h"
#import "ProductService.h"

@implementation ProductPriceDataLoader

- (NSArray*)requestProductListFromDB
{
    return [ProductManager getAllProductsByUseFor:USE_FOR_PRICE sortByKey:@"price" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:USE_FOR_PRICE startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:USE_FOR_PRICE startOffset:startOffset cleanData:NO];
    }        
}

- (BOOL)supportRemote
{
    return YES;
}

- (BOOL)canDelete
{
    return NO;
}

@end

@implementation ProductRebateDataLoader



- (BOOL)supportRemote
{
    return YES;
}

- (BOOL)canDelete
{
    return NO;
}

- (NSArray*)requestProductListFromDB
{
    return [ProductManager getAllProductsByUseFor:USE_FOR_REBATE sortByKey:@"rebate"  sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:USE_FOR_REBATE startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:USE_FOR_REBATE startOffset:startOffset cleanData:NO];
    }        
}

@end

@implementation ProductBoughtDataLoader

- (BOOL)supportRemote
{
    return YES;
}

- (BOOL)canDelete
{
    return NO;
}

- (NSArray*)requestProductListFromDB
{
    return [ProductManager getAllProductsByUseFor:USE_FOR_BOUGHT sortByKey:@"bought" sortAsending:NO];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:USE_FOR_BOUGHT startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:USE_FOR_BOUGHT startOffset:startOffset cleanData:NO];
    }        
}

@end

@implementation ProductDistanceDataLoader

- (BOOL)supportRemote
{
    return YES;
}
- (BOOL)canDelete
{
    return NO;
}

- (NSArray*)requestProductListFromDB
{
    return [ProductManager getAllProductsByUseFor:USE_FOR_DISTANCE sortByKey:@"distance" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:USE_FOR_DISTANCE startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:USE_FOR_DISTANCE startOffset:startOffset cleanData:NO];
    }        
}

@end

@implementation ProductHistoryDataLoader

- (BOOL)supportRemote
{
    return NO;
}

- (BOOL)canDelete
{
    return YES;
}

- (NSArray*)requestProductListFromDB
{
    return [ProductManager getAllProductsByUseFor:USE_FOR_HISTORY sortByKey:@"browseDate" sortAsending:NO];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    [controller productDataRefresh:0];       
}

@end
