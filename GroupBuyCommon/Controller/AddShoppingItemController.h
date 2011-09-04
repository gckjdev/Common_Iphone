//
//  AddShoppingItemController.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController+NumPadReturn.h"
#import "PPTableViewController.h"
#import "UserShoppingItem.h"
#import "ShoppingListController.h"
@interface AddShoppingItemController : PPTableViewController <UITextFieldDelegate>{
	
    NSString*   keywords;
    NSString*   itemId;
    NSDate*     expireDate;
    NSNumber*   maxPrice;
    NSString*   selectedCategory;
    NSMutableArray* selectedSubCategories;
    
    ShoppingListController *shoppingListTableViewController;
    
    BOOL        isShowSubCategory;
    
    int         rowOfCategory;
    int         rowOfSubCategory;
    int         rowOfKeyword;
    int         rowOfValidPeriod;
    int         rowOfPrice;
    int         rowOfRebate;
    int         rowOfCity;
    int         rowNumber;
}

@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSString* keywords;
@property (nonatomic, retain) NSString* itemId;
@property (nonatomic, retain) NSDate*   expireDate;
@property (nonatomic, retain) NSNumber* maxPrice;

@property (nonatomic, retain) NSString* selectedCategory;
@property (nonatomic, retain) NSMutableArray* selectedSubCategories;
@property (nonatomic, retain)  ShoppingListController *shoppingListTableViewController;

-(id) init;
-(id) initWithUserShoppingItem:(UserShoppingItem *)item;

-(IBAction) selectCategory:(id) sender;
-(IBAction) selectSubCategory:(id) sender;

@end
