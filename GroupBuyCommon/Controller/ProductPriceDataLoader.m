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

@synthesize categoryId;

- (id)initWithCategoryId:(NSString*)categoryIdVal
{
    self = [super init];
    self.categoryId = categoryIdVal;
    return self;
}

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
    int useFor = USE_FOR_DISTANCE;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_DISTANCE;
    }
    return [ProductManager getAllProductsByUseFor:useFor sortByKey:@"distance" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    int useFor = USE_FOR_DISTANCE;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_DISTANCE;
    }
    ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:useFor startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:useFor startOffset:startOffset cleanData:NO];
    }        
}

@end

@implementation ProductCategoryDataLoader

@synthesize categoryId;

- (id)initWithCategoryId:(NSString*)categoryIdVal
{
    self = [super init];
    self.categoryId = categoryIdVal;
    return self;
}

- (void)dealloc
{
    [categoryId release];
    [super dealloc];
}

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
    int useFor = [categoryId intValue] + USE_FOR_PER_CATEGORY;
    
    return [ProductManager getAllProductsByUseFor:useFor sortByKey:@"startDate" sortAsending:NO];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    int useFor = [categoryId intValue] + USE_FOR_PER_CATEGORY;
    
    ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:useFor startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:useFor startOffset:startOffset cleanData:NO];
    }        
}

@end


@implementation ProductShoppingItemDataLoader

@synthesize shoppingItemId;

- (id)initWithShoppingItemId:(NSString*)itemId
{
    self = [super init];
    self.shoppingItemId = itemId;
    return self;
}

- (void)dealloc
{
    [shoppingItemId release];
    [super dealloc];
}

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
    int useFor = [shoppingItemId intValue];    
    return [ProductManager getAllProductsByUseFor:useFor sortByKey:@"offset" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    int useFor = [shoppingItemId intValue];
    
    ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:useFor startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:useFor startOffset:startOffset cleanData:NO];
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

@implementation ProductFavoriteDataLoader

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
    return [ProductManager getAllProductsByUseFor:USE_FOR_FAVORITE sortByKey:@"browseDate" sortAsending:NO];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    [controller productDataRefresh:0];       
}

@end

@implementation ProductKeywordDataLoader

@synthesize keyword;

- (id)initWithKeyword:(NSString*)keywordVal
{
	self = [super init];
    self.keyword = keywordVal;
    return self;
		
}


- (void)dealloc
{
    [keyword release];
    [super dealloc];
}

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
    return [ProductManager getAllProductsByUseFor:USE_FOR_KEYWORD sortByKey:@"offset" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
	ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:USE_FOR_KEYWORD startOffset:0 cleanData:YES keyword:keyword];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:USE_FOR_KEYWORD startOffset:startOffset cleanData:NO keyword:keyword];
    }       
}

@end

@implementation ProductTopScoreBelowTenDataLoader

@synthesize categoryId;

- (id)initWithCategoryId:(NSString*)categoryIdVal
{
    self = [super init];
    self.categoryId = categoryIdVal;
    return self;
}

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
    int useFor = USE_FOR_TOPSCORE_BELOW_TEN;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_TOPSCORE_BELOW_TEN;
    }
    return [ProductManager getAllProductsByUseFor:useFor sortByKey:@"offset" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    int useFor = USE_FOR_TOPSCORE_BELOW_TEN;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_TOPSCORE_BELOW_TEN;
    }
	ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:useFor startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:useFor startOffset:startOffset cleanData:NO];
    }       
}

@end

@implementation ProductTopScoreAboveTenDataLoader

@synthesize categoryId;

- (id)initWithCategoryId:(NSString*)categoryIdVal
{
    self = [super init];
    self.categoryId = categoryIdVal;
    return self;
}

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
    int useFor = USE_FOR_TOPSCORE_ABOVE_TEN;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_TOPSCORE_ABOVE_TEN;
    }
    return [ProductManager getAllProductsByUseFor:useFor sortByKey:@"offset" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    int useFor = USE_FOR_TOPSCORE_ABOVE_TEN;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_TOPSCORE_ABOVE_TEN;
    }
	ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:useFor startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:useFor startOffset:startOffset cleanData:NO];
    }       
}

@end

@implementation ProductStartDateDataLoader

@synthesize categoryId;

- (id)initWithCategoryId:(NSString*)categoryIdVal
{
    self = [super init];
    self.categoryId = categoryIdVal;
    return self;
}

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
    int useFor = USE_FOR_STARTDATE;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_STARTDATE;
    }
    return [ProductManager getAllProductsByUseFor:useFor sortByKey:@"offset" sortAsending:YES];
}

- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller
{
    int useFor = USE_FOR_STARTDATE;
    if (nil != self.categoryId) {
        useFor = [categoryId intValue] + USE_FOR_CATEGORY_STARTDATE;
    }
	ProductService* productService = GlobalGetProductService();
    if (isRequestLastest){
        [productService requestProductData:controller useFor:useFor startOffset:0 cleanData:YES];
    }
    else{
        int startOffset = [controller.dataList count];
        [productService requestProductData:controller useFor:useFor startOffset:startOffset cleanData:NO];
    }       
}

@end

