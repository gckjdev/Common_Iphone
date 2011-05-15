//
//  UICheckAndDetailView.m
//  three20test
//
//  Created by qqn_pipi on 10-5-29.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UICheckAndDetailView.h"
#import "UIButtonExt.h"

@implementation UICheckAndDetailView

@synthesize delegate, indexPath, checkMarkButton, disclosureButton;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]){
		
		// add subviews here
		self.checkMarkButton  = [UIButton buttonWithType:UIButtonTypeCustom]; 
		self.disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];

		checkMarkButton.frame = CGRectMake(0, frame.origin.y, 40, 40);
//		[checkMarkButton addTarget:self action:@selector(clickReset:) forControlEvents:UIControlEventTouchUpInside];
		[checkMarkButton setBackgroundImageByName:@"红色对号.png"];
		[checkMarkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		checkMarkButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		
		[self addSubview:checkMarkButton];

		CGRect disclosureButtonFrame = CGRectMake(0, frame.origin.y-5, 40, 40);;
		disclosureButtonFrame.origin.x = checkMarkButton.frame.size.width + 10;
		disclosureButton.frame = disclosureButtonFrame;
		[disclosureButton addTarget:self action:@selector(clickDisclosureButton:) forControlEvents:UIControlEventTouchUpInside];
		[disclosureButton setBackgroundImageByName:@"蓝色箭头圆圈.png"];
		
		[disclosureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		disclosureButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];

		[self addSubview:disclosureButton];
		
	}
	
	return self;
	
}

- (void)showDisclosureButton
{
	disclosureButton.hidden = NO;
}

- (void)hideDisclosureButton
{
	disclosureButton.hidden = YES;
}

- (void)showCheckMark
{
	checkMarkButton.hidden = NO;
}

- (void)hideCheckMark
{
	checkMarkButton.hidden = YES;
}

- (BOOL)isCheck
{
	return !checkMarkButton.hidden;
}

- (void)clickDisclosureButton:(id)sender
{
	if (delegate && [delegate respondsToSelector:@selector(clickDisclosureButtonAtIndexPath:)]){
		[delegate clickDisclosureButtonAtIndexPath:indexPath];
	}
}

- (void)dealloc
{
	[checkMarkButton release];
	[disclosureButton release];
	[indexPath release];
	[super dealloc];
}

@end
