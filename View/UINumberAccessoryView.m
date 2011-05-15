//
//  UINumberAccessoryView.m
//  three20test
//
//  Created by qqn_pipi on 10-5-29.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UINumberAccessoryView.h"
#import "StringUtil.h"

@implementation UINumberAccessoryView

@synthesize detailedImage, numberBackground, numberLabel;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]){
		
		// add subviews here
		self.detailedImage		= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头灰色.png"]] autorelease];
		self.numberBackground	= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] autorelease];
		self.numberLabel		= [[[UILabel alloc] init] autorelease];
		
		numberLabel.textColor	= [UIColor whiteColor];
		numberLabel.font		= [UIFont boldSystemFontOfSize:17];
		numberLabel.backgroundColor = [UIColor clearColor];
		
		numberBackground.frame	= CGRectMake(0, frame.origin.y+8, 30, 40);
		numberLabel.frame		= CGRectMake(0, frame.origin.y+8, 30, 40);
		detailedImage.frame		= CGRectMake(40, frame.origin.y, 40, 40);
		
		numberBackground.hidden = YES;
		numberLabel.hidden = YES;
				
		[self addSubview:detailedImage];
		[self addSubview:numberBackground];
		[self addSubview:numberLabel];
		
	}
	
	return self;
	
}

- (void)setNumber:(int)number
{
	if (number < 0){
		numberBackground.hidden = YES;
		numberLabel.hidden = YES;
		return;
	}

	numberBackground.hidden = NO;
	numberLabel.hidden = NO;
	
	// choose right background image according to number length
	NSString* str = [NSString stringWithInt:number];
	switch ([str length]) {
		case 1:
			numberBackground.image = [UIImage imageNamed:@"红色数字标签－1位数.png"];
			break;
			
		case 2:
			numberBackground.image = [UIImage imageNamed:@"红色数字标签－2位数.png"];
			break;
			
		case 3:
			numberBackground.image = [UIImage imageNamed:@"红色数字标签－3位数.png"];
			break;
			
		case 4:			
		default:
			numberBackground.image = [UIImage imageNamed:@"红色数字标签－4位数.png"];			
			break;
	}
	
//	[numberBackground sizeToFit];
	CGRect rect1 = numberBackground.frame;
	rect1.size = numberBackground.image.size;
	rect1.origin.x = detailedImage.frame.origin.x - rect1.size.width + 10;
	numberBackground.frame = rect1;
	
	CGRect rect2 = numberBackground.frame;
	rect2.origin.x += 9;	
	numberLabel.frame = rect2;
	numberLabel.text  = str;
}

- (void)dealloc
{
	[numberBackground release];
	[numberLabel release];
	[detailedImage release];
	
	[super dealloc];
}

@end
