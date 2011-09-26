//
//  UIBlankView.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-6.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIBlankView.h"

@implementation UIBlankView

@synthesize currentKeyboardResponder, fatherView, initFrame, delegate;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 0.4;
    self.tag = kBlankViewTag;
    
    isRegister = NO;
	return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.currentKeyboardResponder != nil){
		[self.currentKeyboardResponder resignFirstResponder];
	}
	
	if (delegate != nil && [delegate respondsToSelector:@selector(didClickBlankView)]){
		[delegate didClickBlankView];
	}
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	// adjust current view frame
	
	// get keyboard frame
	NSDictionary* info = [notification userInfo];
	NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];	
    CGRect keyboardRect;
    [value getValue:&keyboardRect];
	
	// adjust height 
	// x is fixed : 0, width is fixed, y is given by initialize frame, so the only adjustment is height
	//initFrame.size.height = keyboardRect.size.height - self.initFrame.origin.y + 30;
	
	initFrame.size.height = 400;
	self.frame = initFrame;
	
	// add current view to super view
	// [self.fatherView insertSubview:self atIndex:0];	
	// [self.fatherView bringSubviewToFront:self];    
    
    [self.fatherView addSubview:self];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
	[self removeFromSuperview];
}

- (void)registerKeyboardNotification:(UIView *)theResponder fatherView:(UIView *)theFatherView frame:(CGRect)theFrame
{
	if (isRegister == YES)
		return;
	
    NSLog(@"<BlankView> registerKeyboardNotification");
    
	// set current keyboard responder
	self.currentKeyboardResponder = theResponder;
	self.fatherView = theFatherView;
	self.initFrame = theFrame;
	
	// create notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	
	isRegister = YES;
}

- (void)deregsiterKeyboardNotification
{
    NSLog(@"<BlankView> deregsiterKeyboardNotification");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];	
	
	isRegister = NO;
}

- (void)dealloc
{
	[currentKeyboardResponder release];
	[fatherView release];
	[super dealloc];
}

@end
