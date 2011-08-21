//
//  AddShoppingItemController.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface AddShoppingItemController : PPTableViewController {
	

}

@property (nonatomic, retain) NSString* itemName;
-(IBAction) selectCategory:(id) sender;
-(IBAction) selectSubCategory:(id) sender;

@end
