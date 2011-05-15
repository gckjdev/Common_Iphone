//
//  CustomIndexView.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-3.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "CustomIndexView.h"


@implementation CustomIndexView

@synthesize indexArray;
@synthesize tableView;
@synthesize backgroundImage;

- (id)initWithFrame:(CGRect)frame indexArray:(NSArray*)indexArrayVal tableView:(UITableView*)tableViewVal backgroundImage:(NSString*)backgroundImageName
{
	if (self = [super initWithFrame:frame]){
		self.indexArray = indexArrayVal;
		self.tableView = tableViewVal;		
		self.backgroundImage = [UIImage imageNamed:backgroundImageName];
		self.backgroundColor = [UIColor clearColor];
		self.alpha = 1.0;

	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	UIFont* font = [UIFont systemFontOfSize:8];
	
	float width = 15.0f;
	float height = 15.0f;
	int   x = rect.origin.x + 5;
	int   y = rect.origin.y + 5;
	
	CGRect textRect = CGRectMake(x, y, width, height);
	for (NSString* indexText in indexArray){
		
		[indexText drawInRect:textRect withFont:font];
		
		y += height;
		textRect.origin.y = y;
	}
	
	if (backgroundImage != nil){
		[backgroundImage drawInRect:rect];
	}
	
}

- (void)dealloc
{
	[indexArray release];
	[tableView release];
	[backgroundImage release];

	[super dealloc];
}

@end
