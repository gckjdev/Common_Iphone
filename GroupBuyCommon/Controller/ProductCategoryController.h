//
//  ProductCategoryController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ProductService.h"

@class CommonProductListController;

@interface ProductCategoryController : PPTableViewController<ProductServiceDelegate> {
    
    UIViewController   *superController;    
    BOOL todayOnly;
    NSDictionary       *categoryControllerList;
}
@property (nonatomic, retain) UIViewController   *superController;
@property (nonatomic, assign) BOOL todayOnly;
@property (nonatomic, assign) NSDictionary            *categoryControllerList;

@end
