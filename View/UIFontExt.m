//
//  UIFontExt.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-13.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIFontExt.h"


@implementation UIFont(UIFontExt)

+ (UIFont *)coolFontWithSize:(int)size
{
	return [UIFont fontWithName:@"Verdana" size:size];
}

+ (UIFont *)coolFontBoldWithSize:(int)size
{
	return [UIFont fontWithName:@"Verdana-Bold" size:size];
}

@end
