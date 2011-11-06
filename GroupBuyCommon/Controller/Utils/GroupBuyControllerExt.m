//
//  GroupBuyControllerExt.m
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupBuyControllerExt.h"

UIView* _groupbuyAccessoryView;

@implementation PPViewController (GroupBuyControllerExt)

+ (UIView*)groupbuyAccessoryView
{
//    TODO code below doesn't work, don't know why yet
//    if (_groupbuyAccessoryView == nil){
//        _groupbuyAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tu_105-51.png"]];
//    }
    
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tu_105-51.png"]];
}

+ (UIView*)getFooterView
{
    UIImage *image = [UIImage imageNamed:@"tu_179.png"];
    UIImageView *footerImageView = [[UIImageView alloc] initWithImage:image];
    [footerImageView setFrame:CGRectMake(7, 0, 320-7*2, 2)];
    UIView *view = [[[UIView alloc] init] autorelease];
    [view addSubview:footerImageView];
    [footerImageView release];
    return view;
}

- (UIColor*)getDefaultTextColor
{
    return [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
}

@end
