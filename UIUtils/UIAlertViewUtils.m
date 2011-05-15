//
//  UIAlertViewUtil.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-24.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIAlertViewUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIAlertView (UIAlertViewExt)

- (void)showWithBackground
{
	[self show];
	
	// for testing, will be moved to common features
	UIImage *theImage = [UIImage imageNamed:@"black-background.png"];    
//	UIImage *theImage = [UIImage imageNamed:@"barbackground.png"];    
	
	if (theImage == nil)
		return;
	
	theImage = [theImage stretchableImageWithLeftCapWidth:0. topCapHeight:0.];
	CGSize theSize = self.frame.size;
	
	UIGraphicsBeginImageContext(theSize);    
	[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];    
	theImage = UIGraphicsGetImageFromCurrentImageContext();    
	UIGraphicsEndImageContext();
	
	self.layer.contents = (id)[theImage CGImage];			
}

@end
