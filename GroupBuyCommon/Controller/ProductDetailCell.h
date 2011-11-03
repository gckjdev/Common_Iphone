//
//  ProductDetailCell.h
//  groupbuy
//
//  Created by  on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewCell.h"
#import "HJManagedImageV.h"
@class Product;
//@class HJManagedImageV;

@protocol ProductDetailCellDelegate <NSObject>

- (void)clickUp:(id)sender;
- (void)clickDown:(id)sender;

@end

@interface ProductDetailCell : PPTableViewCell<HJManagedImageVDelegate>
{
    Product *productInfo;
    id<ProductDetailCellDelegate>productDetailCellDelegate;
}
@property (retain, nonatomic) IBOutlet HJManagedImageV *productImage;
@property (retain, nonatomic) IBOutlet Product *productInfo;
@property (retain, nonatomic) IBOutlet UILabel *rebateLabel;
@property (retain, nonatomic) IBOutlet UILabel *valueLabel;
@property (retain, nonatomic) IBOutlet UILabel *boughtLabel;
@property (retain, nonatomic) IBOutlet UILabel *upLabel;
@property (retain, nonatomic) IBOutlet UILabel *downLabel;

@property (retain, nonatomic) IBOutlet UILabel *priceIntegerLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceDecimalLabel;
@property (retain, nonatomic) IBOutlet UILabel *yuanLabel;
@property (nonatomic, assign) id<ProductDetailCellDelegate>productDetailCellDelegate;

+ (ProductDetailCell*) createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
- (void)setCellInfo:(Product *)product;

- (IBAction)clickUp:(id)sender;
- (IBAction)clickDown:(id)sender;

@end
