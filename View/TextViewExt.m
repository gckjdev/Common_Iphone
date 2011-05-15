//
//  TextViewExt.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-5.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "TextViewExt.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextView (UITextViewExt)

- (void)setRoundRectStyle
{
	[self.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.layer setBorderWidth: 2.0];
    [self.layer setCornerRadius:8.0f];
    [self.layer setMasksToBounds:YES];
	
}

@end
