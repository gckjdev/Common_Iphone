//
//  ShoppingListController.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ShoppingListCell.h"

@interface ShoppingListController : PPTableViewController <ShoppingListCellDelegate> {

    UILabel *helpLabel;
    int     tabIndex;
}

@property (nonatomic, retain) IBOutlet UILabel *helpLabel;
@property (nonatomic, assign) int               tabIndex;

- (void)updateTabBadge:(NSString*)value;

@end
