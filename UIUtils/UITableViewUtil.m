//
//  UITableViewUtil.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UITableViewUtil.h"


@implementation UITableView ( UITableViewUtil ) 

- (void)shiftToNextTextView
{
}

- (UITableViewCell *)getCellByRow:(int)row
{
	NSUInteger index[] = {0, row};
	NSIndexPath *indexPath = [[[NSIndexPath alloc] initWithIndexes:index length:2] autorelease];
	
	// get cell
	return [self cellForRowAtIndexPath:indexPath];	
}

- (UITableViewCell *)getCellBySection:(int)section row:(int)row
{
	NSUInteger index[] = {section, row};
	NSIndexPath *indexPath = [[[NSIndexPath alloc] initWithIndexes:index length:2] autorelease];
	
	// get cell
	return [self cellForRowAtIndexPath:indexPath];	
}


@end
