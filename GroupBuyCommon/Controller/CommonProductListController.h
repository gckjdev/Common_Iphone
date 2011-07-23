//
//  CommonProductListController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface CommonProductListController : PPTableViewController {
    
    UIViewController     *superController;
}

@property (nonatomic, retain) UIViewController     *superController;

@end
