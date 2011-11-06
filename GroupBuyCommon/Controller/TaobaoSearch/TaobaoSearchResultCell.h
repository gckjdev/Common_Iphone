//
//  TaobaoSearchResultCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "HJManagedImageV.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@interface TaobaoSearchResultCell : PPTableViewCell {
    
    UILabel *titleLabel;
    OHAttributedLabel *priceLabel;
    UILabel *priceGapLabel;
    UILabel *valueGapLabel;
    HJManagedImageV *imageView;
}

+ (TaobaoSearchResultCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

@property (nonatomic, retain) IBOutlet HJManagedImageV *imageView;
@property (nonatomic, retain) IBOutlet UILabel *valueGapLabel;
- (void)setCellInfoWithProduct:(NSDictionary*)taobaoProduct 
                     indexPath:(NSIndexPath*)indexPath
                         price:(double)price
                         value:(double)value;
@property (nonatomic, retain) IBOutlet UILabel *priceGapLabel;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet OHAttributedLabel *priceLabel;

@end
