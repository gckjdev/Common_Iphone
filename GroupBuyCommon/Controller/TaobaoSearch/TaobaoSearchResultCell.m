//
//  TaobaoSearchResultCell.m
//  groupbuy
//
//  Created by qqn_pipi on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TaobaoSearchResultCell.h"
#import "PPApplication.h"

@implementation TaobaoSearchResultCell
@synthesize imageView;
@synthesize valueGapLabel;
@synthesize priceGapLabel;
@synthesize titleLabel;
@synthesize priceLabel;

// just replace PPTableViewCell by the new Cell Class Name
+ (TaobaoSearchResultCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TaobaoSearchResultCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <TaobaoSearchResultCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((TaobaoSearchResultCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (TaobaoSearchResultCell*)[topLevelObjects objectAtIndex:0];
}

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

+ (NSString*)getCellIdentifier
{
    return @"TaobaoSearchResultCell";
}

+ (CGFloat)getCellHeight
{
    return 75.0f;
}

- (void)setCellInfoWithProduct:(NSDictionary*)taobaoProduct 
                     indexPath:(NSIndexPath*)indexPath
                         price:(double)price
                         value:(double)value

{
    NSString *name = [taobaoProduct objectForKey:@"title"];    
    NSString *taobaoPrice = [taobaoProduct objectForKey:@"price"];
    NSString *shop = [taobaoProduct objectForKey:@"nick"];
    NSString *image = [taobaoProduct objectForKey:@"pic_url"];
    double   taobaoDoublePrice = [taobaoPrice doubleValue];
    
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】 %@", shop, name];
    self.titleLabel.numberOfLines = 3;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ 元", taobaoPrice];
    if ( taobaoDoublePrice > price ){
        self.priceGapLabel.text = [NSString stringWithFormat:@"[ +%.2f ]", taobaoDoublePrice - price];
        self.priceGapLabel.textColor = [UIColor blueColor];
    }
    else{
        self.priceGapLabel.text = [NSString stringWithFormat:@"[ %.2f ]", taobaoDoublePrice - price];
        self.priceGapLabel.textColor = [UIColor redColor];
    }

    self.valueGapLabel.text = @"";
//    if ( taobaoDoublePrice > value ){
//        self.valueGapLabel.text = [NSString stringWithFormat:@"＋%.2f 元", taobaoDoublePrice - value];
//        self.valueGapLabel.textColor = [UIColor blueColor];
//    }
//    else {
//        self.valueGapLabel.text = [NSString stringWithFormat:@"%.2f 元", taobaoDoublePrice - value];
//        self.valueGapLabel.textColor = [UIColor redColor];
//    }
    
    self.imageView.hidden = YES;
//    self.imageView.callbackOnSetImage = self;
//    [self.imageView clear];
//    self.imageView.url = [NSURL URLWithString:image];
//    [GlobalGetImageCache() manage:self.imageView];

}


- (void)dealloc {
    [titleLabel release];
    [priceLabel release];
    [priceGapLabel release];
    [valueGapLabel release];
    [imageView release];
    [super dealloc];
}
@end
