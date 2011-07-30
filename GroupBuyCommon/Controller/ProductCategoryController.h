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

@interface ProductCategoryController : PPTableViewController<ProductServiceDelegate> {
        UIViewController                *superController;
    
    BOOL todayOnly;
    NSMutableArray *indexNameArray;
}
@property (nonatomic, retain) UIViewController                *superController;
@property (nonatomic, assign) BOOL todayOnly;
@property (nonatomic, retain) NSMutableArray  *indexNameArray;


@end
