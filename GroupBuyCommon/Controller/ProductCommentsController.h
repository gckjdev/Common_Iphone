//
//  ProductCommentsController.h
//  groupbuy
//
//  Created by penglzh on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"


@interface ProductCommentsController : PPTableViewController {
    NSString *productId;
}

@property (nonatomic, retain) NSString *productId;

@end
