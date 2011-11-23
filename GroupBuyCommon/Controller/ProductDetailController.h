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
#import "ProductDetailCell.h"

@class Product;
@class ActionHandler;
@interface ProductDetailController : PPTableViewController <HJManagedImageVDelegate, UIActionSheetDelegate, ProductServiceDelegate, ProductDetailCellDelegate> {
    Product *product;
    UILabel *priceLabel;
    UILabel *rebateLabel;
    UILabel *saveLabel;
    UILabel *boughtLabel;
    
    UILabel *upLabel;
    UILabel *downLabel;
    HJManagedImageV *imageView;
    ActionHandler *actionHandler;
}

@property (nonatomic, retain) Product *product;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *rebateLabel;
@property (nonatomic, retain) IBOutlet UILabel *saveLabel;
@property (nonatomic, retain) IBOutlet UILabel *boughtLabel;
@property (retain, nonatomic) IBOutlet UIButton *buyButton;

@property (retain, nonatomic) IBOutlet UIButton *savaButton;
@property (retain, nonatomic) IBOutlet UIButton *forwardButton;
@property (retain, nonatomic) IBOutlet UIButton *commetButton;


@property (nonatomic, retain) HJManagedImageV *imageView;
@property (nonatomic, retain) ActionHandler *actionHandler;

- (IBAction)clickBuy:(id)sender;
- (IBAction)clickSave:(id)sender;
- (IBAction)clickForward:(id)sender;

- (IBAction)clickComment:(id)sender;

+ (void)showProductDetail:(Product*)product navigationController:(UINavigationController*)navigationController isCreateHistory:(BOOL)isCreateHistory;

@end
