//
//  UIDataButton.m
//  three20test
//
//  Created by qqn_pipi on 10-5-18.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIDataButton.h"


@implementation UIDataButton

@synthesize data;

- (void)dealloc
{
	[data release];
	[super dealloc];
}

@end
