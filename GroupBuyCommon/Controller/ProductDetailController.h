//
//  ProductDetailController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "HJManagedImageV.h"
#import "ProductService.h"

@class Product;

@interface ProductDetailController : PPTableViewController <HJManagedImageVDelegate, UIActionSheetDelegate, ProductServiceDelegate> {
    Product *product;
    UILabel *priceLabel;
    UILabel *rebateLabel;
    UILabel *saveLabel;
    UILabel *boughtLabel;
    
    UILabel *upLabel;
    UILabel *downLabel;
    
    HJManagedImageV *imageView;
}

@property (nonatomic, retain) Product *product;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *rebateLabel;
@property (nonatomic, retain) IBOutlet UILabel *saveLabel;
@property (nonatomic, retain) IBOutlet UILabel *boughtLabel;

@property (nonatomic, retain) IBOutlet UILabel *upLabel;
@property (nonatomic, retain) IBOutlet UILabel *downLabel;

@property (nonatomic, retain) HJManagedImageV *imageView;

- (IBAction)clickBuy:(id)sender;
- (IBAction)clickSave:(id)sender;
- (IBAction)clickForward:(id)sender;

- (IBAction)clickUp:(id)sender;
- (IBAction)clickDown:(id)sender;
- (IBAction)clickComment:(id)sender;

+ (void)showProductDetail:(Product*)product navigationController:(UINavigationController*)navigationController isCreateHistory:(BOOL)isCreateHistory;

@end
