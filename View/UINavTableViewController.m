//
//  UINavTableViewController.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UINavTableViewController.h"


@implementation UINavTableViewController

@synthesize nav;

- (void)dealloc
{
	[nav release];
	[super dealloc];
}

- (void)clickCancel:(id)sender
{
	[nav popViewControllerAnimated:YES];
}

@end
