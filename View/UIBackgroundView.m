//
//  UIBackgroundView.m
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-13.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIBackgroundView.h"


@implementation UIBackgroundView

@synthesize imageView;

- (id)initWithImageName:(NSString *)name inView:(UIView *)inView
{
	if (self == nil){

		self = [super initWithFrame:inView.bounds];
		
		// set background color to clear
		inView.backgroundColor = [UIColor clearColor];	

		// create a image view
		self.imageView = [[UIImageView alloc] initWithFrame:inView.bounds];
		
		[imageView setImage:[UIImage imageNamed:name]];		
	}
	
	return self;
}

- (void)dealloc
{
	
	[imageView release];
	
	[super dealloc];
}

@end
