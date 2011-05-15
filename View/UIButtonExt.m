//
//  UIButtonExt.m
//  Test
//
//  Created by Peng Lingzhe on 5/21/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UIButtonExt.h"


@implementation UIButton (UIButtonExt)

- (void)setBackgroundImage:(UIImage*)image
{
	CGRect rect;
	rect	   = self.frame;	
	rect.size  = image.size;			// set button size as image size
	self.frame = rect;
	
	[self setBackgroundImage:image forState:UIControlStateNormal];	
}

- (void)setBackgroundImageByName:(NSString*)imageName
{
	[self setBackgroundImage:[UIImage imageNamed:imageName]];
}

@end
