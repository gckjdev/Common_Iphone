//
//  ProductDetailCell.m
//  groupbuy
//
//  Created by  on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailCell.h"
#import "HJManagedImageV.h"
#import "HJObjManager.h"
#import "Product.h"
#import "PPApplication.h"
#import "ProductService.h"
#import "NumberUtil.h"
#import "NSAttributedString+Attributes.h"
#import "FontUtils.h"
#import "OHAttributedLabel.h"


@implementation ProductDetailCell
@synthesize productImage;
@synthesize rebateLabel;
@synthesize valueLabel;
@synthesize boughtLabel;
@synthesize upLabel;
@synthesize downLabel;
@synthesize priceLabel;
@synthesize productDetailCellDelegate;


- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		   
}

- (void)awakeFromNib{
    [self setCellStyle];
}

// just replace ProductDetailCell by the new Cell Class Name
+ (ProductDetailCell*) createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProductDetailCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ProductDetailCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ProductDetailCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ProductDetailCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"ProductDetailCell";
}

+ (CGFloat)getCellHeight
{
    return 160.0f;
}



- (void)setCellInfo:(Product *)product
{
    //set product image
    #define IMAGE_VIEW_TAG 1299
    self.productImage.tag = IMAGE_VIEW_TAG;
    self.productImage.backgroundColor = [UIColor clearColor];
    self.productImage.callbackOnSetImage = self;    
    [self.productImage clear];
    self.productImage.url = [NSURL URLWithString:product.image];
    [GlobalGetImageCache() manage:self.productImage];
    
    //set product price

    if (product.price) {
        
        NSInteger priceInteger = [product.price integerValue];
        NSInteger priceDecimal = getDecimal([product.price floatValue]);
        NSString* priceText = nil;
        if (priceDecimal == 0) {
            priceText = [NSString stringWithFormat:@"%d元", priceInteger];
        }else{
            priceText = [NSString stringWithFormat:@"%d.%d元", priceInteger,priceDecimal];
        }
        
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:priceText];
        
        [attrStr setFont:[FontUtils HeitiSC:24]];
        [attrStr setTextColor:[UIColor colorWithRed:245/255.0 green:109/255.0 blue:42/255.0 alpha:1.0f]];    
        [attrStr setTextColor:[UIColor colorWithRed:111/255.0f green:104/255.0f blue:94/255.0f alpha:1.f] range:[priceText rangeOfString:@"元"]];
        [attrStr setFont:[FontUtils HeitiSC:12] range:[priceText rangeOfString:@"元"]];
        
        if (priceDecimal != 0) {
            NSString *text = [NSString stringWithFormat:@".%d",priceDecimal];
            [attrStr setFont:[FontUtils HeitiSC:18] range:[priceText rangeOfString:text]];
        }

        self.priceLabel.attributedText = attrStr;
        self.priceLabel.backgroundColor = [UIColor clearColor];
        [self.priceLabel setTextAlignment:UITextAlignmentCenter];
    }
    
    
    //other vars
    if (product.rebate && [product.rebate intValue] < 10) {        
        NSString *rebate = [NSString stringWithFormat:@"%@折",[product.rebate description]];
        [self.rebateLabel setText:rebate];
    }else{
        [self.rebateLabel setText:@"无"];
    }
    
    if (product.value) {
        [self.valueLabel setText:[product.value description]];
    }else{
        [self.valueLabel setText:nil];
    }
    
    if (product.bought) {
        [self.boughtLabel setText:[product.bought description]];
    }else{
        [self.boughtLabel setText:@"0"];
    }
    

    [self.upLabel setText:[product.up description]];
    [self.downLabel setText:[product.down description]];
}


#pragma delegate
-(void) managedImageSet:(HJManagedImageV*)mi
{
    
}
-(void) managedImageCancelled:(HJManagedImageV*)mi
{
    
}

- (IBAction)clickUp:(id)sender
{
    if (productDetailCellDelegate && [productDetailCellDelegate respondsToSelector:@selector(clickUp:)]) {
        [self.productDetailCellDelegate clickUp:sender];
    }
}

- (IBAction)clickDown:(id)sender
{
    if (productDetailCellDelegate && [productDetailCellDelegate respondsToSelector:@selector(clickDown:)]) {
        [self.productDetailCellDelegate clickDown:sender];
    }
}

- (void)dealloc {
    [productImage release];
    [rebateLabel release];
    [valueLabel release];
    [boughtLabel release];
    [upLabel release];
    [downLabel release];
    [priceLabel release];
    [super dealloc];
}
@end
