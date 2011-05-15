//
//  UIBgTabController.m
//  three20test
//
//  Created by qqn_pipi on 10-2-22.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIBgTabController.h"


@implementation UIBgTabController

@synthesize backgroundImageFile;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect frame = CGRectMake(0, 0, 480, 49);

	UIView *viewWithColor = [[UIView alloc] initWithFrame:frame];
	UIImage *backgroundImage = [UIImage imageNamed:backgroundImageFile];
	UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
	viewWithColor.backgroundColor = backgroundColor;
	[backgroundColor release];
	[[self tabBar] insertSubview:viewWithColor atIndex:0];
	[viewWithColor release];
	
}

- (void)dealloc
{
	[backgroundImageFile release];
	
	[super dealloc];
}

@end
