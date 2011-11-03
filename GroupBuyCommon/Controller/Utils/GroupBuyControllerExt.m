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

@end
