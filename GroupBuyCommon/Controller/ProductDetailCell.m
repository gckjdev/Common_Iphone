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


@implementation ProductDetailCell
@synthesize productImage;
@synthesize rebateLabel;
@synthesize valueLabel;
@synthesize boughtLabel;
@synthesize upLabel;
@synthesize downLabel;
@synthesize priceIntegerLabel;
@synthesize priceDecimalLabel;
@synthesize yuanLabel;
@synthesize productInfo;
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

- (BOOL)isInteger:(CGFloat)number
{
    NSInteger integer = number;
    if (number - integer == 0.0) {
        return YES;
    }
    return NO;
}

- (NSInteger)getDecimal:(CGFloat)number
{
//    const int W = 3;
    NSString *str = [NSString stringWithFormat:@"%0.2f",number];
    NSRange range = [str rangeOfString:@"."];
    NSInteger start = range.location + 1;
    int i = [str length] - 1;
    for (; i >= start; --i) {
        if ([str characterAtIndex:i] != '0') {
            break;
        }
    }
    int sum = 0;
    for (int j = start; j <= i; j++) {
        sum *= 10;
        sum += [str characterAtIndex:j] - '0';
    }
    return sum;
//    str = [str substringFromIndex:]
}

- (void)setYuanXOffset:(NSInteger)x
{
    [self.yuanLabel setFrame:CGRectMake(x, yuanLabel.frame.origin.y, 
                                        yuanLabel.frame.size.width, yuanLabel.frame.size.height)];
}

- (void)setCellInfo:(Product *)product
{
    self.productInfo = product;
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
        CGFloat price = [product.price floatValue];
        NSInteger integer = price;
        NSInteger decimal = [self getDecimal:price];
        if (decimal == 0) {
            self.priceIntegerLabel.text = [NSString stringWithFormat:@"%d",integer];
            self.priceDecimalLabel.text = nil;
            [self setYuanXOffset:261];
        }else{
            self.priceIntegerLabel.text = [NSString stringWithFormat:@"%d.",integer];
            self.priceDecimalLabel.text = [NSString stringWithFormat:@"%d",decimal];
            if (decimal > 10) {
                [self setYuanXOffset:281];
            }else{
                [self setYuanXOffset:273];
            }
        }
        [self.yuanLabel setHidden:NO];
    }else{
        self.priceIntegerLabel.text = nil;
        self.priceDecimalLabel.text = nil;
        [self.yuanLabel setHidden:YES];
    }
        
    //other vars
    if (product.rebate) {
        NSString *rebate = [NSString stringWithFormat:@"%@折",[product.rebate description]];
        [self.rebateLabel setText:rebate];
    }else{
        [self.rebateLabel setText:nil];
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
    [priceIntegerLabel release];
    [priceDecimalLabel release];
    [yuanLabel release];
    [productInfo release];
    [super dealloc];
}
@end
