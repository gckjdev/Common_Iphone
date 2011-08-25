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
	
    NSString*   keywords;
    NSString*   itemId;
}

@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSString* keywords;
@property (nonatomic, retain) NSString* itemId;

-(IBAction) selectCategory:(id) sender;
-(IBAction) selectSubCategory:(id) sender;

@end
