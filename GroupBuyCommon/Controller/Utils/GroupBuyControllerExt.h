//
//  GroupBuyControllerExt.h
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPViewController.h"
#import "UITableViewCellUtil.h"

#define FIRST_CELL_IMAGE    @"tu_56.png"
#define MIDDLE_CELL_IMAGE   @"tu_69.png"
#define LAST_CELL_IMAGE     @"tu_86.png"
#define SINGLE_CELL_IMAGE   @"tu_60.png"

@interface PPViewController (GroupBuyControllerExt) 

+ (UIView*)groupbuyAccessoryView;
+ (UIView*)getFooterView;

- (UIColor*)getDefaultTextColor;

@end
