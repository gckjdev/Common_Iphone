//
//  UITextFieldForCell.m
//  Redial
//
//  Created by Peng Lingzhe on 8/3/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UITextFieldForCell.h"


@implementation UITextFieldForCell

@synthesize indexPath;

- (void)dealloc
{
	[indexPath release];
	[super dealloc];
}

@end
