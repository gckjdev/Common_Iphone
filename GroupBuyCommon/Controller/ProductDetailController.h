//
//  ProductDetailController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@class Product;

@interface ProductDetailController : PPTableViewController {
    Product *product;
    UILabel *priceLabel;
    UILabel *rebateLabel;
    UILabel *saveLabel;
    UILabel *boughtLabel;
}

@property (nonatomic, retain) Product *product;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *rebateLabel;
@property (nonatomic, retain) IBOutlet UILabel *saveLabel;
@property (nonatomic, retain) IBOutlet UILabel *boughtLabel;

- (IBAction)clickBuy:(id)sender;

@end
