//
//  ProductTextCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "HJManagedImageV.h"

@class Product;

@interface ProductTextCell : PPTableViewCell <HJManagedImageVDelegate> {
    
    UILabel *productDescLabel;
    UILabel *valueLabel;
    UILabel *priceLabel;
    UILabel *rebateLabel;
    UILabel *leftTimeLabel;
    UILabel *distanceLabel;
    UILabel *boughtLabel;
    HJManagedImageV *imageView;
}
@property (nonatomic, retain) IBOutlet HJManagedImageV *imageView;
+ (ProductTextCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCellInfoWithProduct:(Product*)product indexPath:(NSIndexPath*)indexPath;
- (void)setCellInfoWithProductDictionary:(NSDictionary*)product indexPath:(NSIndexPath*)indexPath;

@property (nonatomic, retain) IBOutlet UILabel *productDescLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;
@property (nonatomic, retain) IBOutlet UILabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *rebateLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *boughtLabel;

@end

