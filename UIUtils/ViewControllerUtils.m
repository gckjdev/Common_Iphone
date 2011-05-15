//
//  ViewControllerUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-4-6.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "ViewControllerUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIViewController (UIViewControllerUtils)



- (void)setLeftBackButton:(SEL)selector
{
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"")
																			 style:UIBarButtonItemStylePlain
																			target:self 
																			action:selector];
}

- (void)setLeftCancelButton:(SEL)selector
{
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
																			 style:UIBarButtonItemStylePlain
																			target:self 
																			action:selector];
}

- (void)clickBack:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)addAnimation:(int)tag
{
	//	CATransition *animation = [CATransition animation];
	//	animation.delegate = self;
	//	animation.duration = 0.75f;
	//	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	//	animation.type = kCATransitionFade;
	//	animation.subtype = kCATransitionFromLeft;
	//	[[self.view layer] addAnimation:animation forKey:@"animation display"];	
	
	// add animation here
	CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
	
	switch (tag) {
		case 0:
			animation.type = kCATransitionPush;
			animation.subtype = kCATransitionFromTop;
			break;
		case 1:
			animation.type = kCATransitionMoveIn;
			animation.subtype = kCATransitionFromTop;
			break;
		case 2:
			animation.type = kCATransitionReveal;
			animation.subtype = kCATransitionFromTop;
			break;
		case 3:
			animation.type = kCATransitionFade;
			animation.subtype = kCATransitionFromTop;
			break;
		default:
			break;
	}	
}

- (void)clickRemoveFromSuperView:(id)sender
{
	[self.view removeFromSuperview];
}


@end
