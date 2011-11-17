//
//  CommonProductListController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ProductService.h"

@class CommonProductListController;

enum PRODUCT_DISPLAY_TYPE{

    PRODUCT_DISPLAY_GROUPBUY,
    PRODUCT_DISPLAY_TAOBAO
};

@protocol ProductDataLoader <NSObject>

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

- (BOOL)supportRemote;
- (BOOL)canDelete;

@end

@interface CommonProductListController : PPTableViewController <ProductServiceDelegate> {
    
    UIViewController                *superController;
    NSObject<ProductDataLoader>     *dataLoader;
    NSString                        *categoryId;
    NSString                        *type;
    BOOL                            isRemoteRequest;
    NSInteger                       appearCount;
    
    Class                           productDisplayClass;
}

@property (nonatomic, retain) UIViewController                *superController;
@property (nonatomic, retain) NSObject<ProductDataLoader>     *dataLoader;
@property (nonatomic, retain) NSString                        *categoryId;
@property (nonatomic, retain) NSString                        *type;
@property (nonatomic, assign) int                             productDisplayType;

@end

extern int GlobalGetProductDisplayType();