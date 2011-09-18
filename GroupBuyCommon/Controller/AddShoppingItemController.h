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
#import "PPMKMapViewController.h"

#import "ShoppingKeywordCell.h"
#import "ShoppingCategoryCell.h"
#import "ShoppingSubCategoryCell.h"
#import "ShoppingValidPeriodCell.h"
#import "LocationCell.h"
#import "SliderCell.h"

@interface AddShoppingItemController : PPTableViewController <UITextFieldDelegate, MKReverseGeocoderDelegate, PriceCellDelegate, KeywordCellDelegate, LocationCellDelegate>{
	
    NSString*   itemId;
    
    ShoppingListController *shoppingListTableViewController;
    
    BOOL        isShowSubCategory;
    
    int         rowOfCategory;
    int         rowOfSubCategory;
    int         rowOfKeyword;
    int         rowOfValidPeriod;
    int         rowOfPrice;
    int         rowOfLocation;
    int         rowOfRebate;
    int         rowOfCity;
    int         rowNumber;
    
    //cell 
    ShoppingCategoryCell *categoryCell;
    ShoppingSubCategoryCell *subCategoryCell;
    ShoppingKeywordCell *keywordCell;
    ShoppingValidPeriodCell *validPeriodCell;
    SliderCell *priceCell;
    LocationCell *locationCell;
}

@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSString* itemId;

@property (nonatomic, retain)  ShoppingListController *shoppingListTableViewController;

//cell
@property (nonatomic, retain) ShoppingCategoryCell *categoryCell;
@property (nonatomic, retain) ShoppingSubCategoryCell *subCategoryCell;
@property (nonatomic, retain) ShoppingKeywordCell *keywordCell;
@property (nonatomic, retain) ShoppingValidPeriodCell *validPeriodCell;
@property (nonatomic, retain) SliderCell *priceCell;
@property (nonatomic, retain) LocationCell *locationCell;



-(id) init;
-(id) initWithUserShoppingItem:(UserShoppingItem *)item;

-(IBAction) selectCategory:(id) sender;
-(IBAction) selectSubCategory:(id) sender;

@end
