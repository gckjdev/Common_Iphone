//
//  UIHideButton.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-8.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UIHideButton.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIViewController (UIResignKeyboard)

- (UIButton *)createButton:(UIView *)v
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	button.frame = v.frame;
	
	[button addTarget:self action:@selector(resignKeyboard:) forControlEvents:UIControlEventTouchUpInside];
	
	[v addSubview:button];
	
	[v sendSubviewToBack:button];	
	
	return button;
}

- (void)resignKeyboard:(id)sender
{	
	NSLog(@"resignKeyboard");
	[UIViewController resignKeyboardByView:self.view];
}

+ (BOOL)resignKeyboardByView:(UIView *)aView
{
	BOOL ret = NO;

	// check view itself
	if ([aView isKindOfClass:[UITextView class]] || [aView isKindOfClass:[UITextField class]]){
		if ([aView isFirstResponder]){
			//NSLog(@"resignKeyboardByView resignFirstResponder");
			[aView resignFirstResponder];
			return YES;
		}
	}
	
	// repeat for view's sub view
	for (UIView* subView in aView.subviews){
		ret = [self resignKeyboardByView:subView];
		if (ret == YES)
			return ret;
	}	

	return ret;
}

	
	
@end
