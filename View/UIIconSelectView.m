//
//  UIIconSelectView.m
//  three20test
//
//  Created by qqn_pipi on 10-2-22.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIIconSelectView.h"
#import <UIKit/UIKit.h>

@implementation UIIconSelectView

@synthesize iconArray;
@synthesize selectedImageName;
@synthesize iconNameArray;
@synthesize delegate;
 
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]){
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	// draw something here
	
//	CGContextRef context = UIGraphicsGetCurrentContext();	
	
	static int kIconHeight	= 57;
	static int kIconWidth	= 57;
	
	int count	= 0;
	int left	= rect.origin.x + kMarginWidthForIcon;	
	int top		= rect.origin.y + kMarginHeightForIcon;
	
	for (UIImage* image in iconArray){
		
		CGPoint point = CGPointMake(left, top);
		
		[image drawAtPoint:point];
		
		// set TOP & LEFT for next icon		
		count ++;		
		if (count % kColumnNumberForIconList == 0){
			top		= top + kIconHeight + kMarginHeightForIcon;
			left	= rect.origin.x + kMarginWidthForIcon;				// reset to start left
		}
		else {
			left	= left + kIconWidth + kMarginWidthForIcon;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];
	CGPoint point  = [touch locationInView:self];
	int icon_width = 57 + kMarginWidthForIcon;
	int icon_height = 57 + kMarginHeightForIcon;
	
	int y1 = point.y / icon_height;
	int x1 = point.x / icon_width;
	
	int index = y1 * kColumnNumberForIconList + x1 + 1;

	
	if (index <= [iconArray count]){
		self.selectedImageName = [iconNameArray objectAtIndex:(index-1)];
		NSLog(@"Number %d selected, Image Name is %@", index, self.selectedImageName);
		
		if (delegate != nil && [delegate respondsToSelector:@selector(iconSelectView:didSelectImage:imageName:)]) {
			[delegate iconSelectView:self didSelectImage:[iconArray objectAtIndex:(index-1)] imageName:self.selectedImageName];
		}
	}


	
}

- (void)setIconList:(NSArray *)nameArray
{
	NSMutableArray* arr = [[NSMutableArray alloc] init];
	for (NSString* name in nameArray){
		UIImage* image = [UIImage imageNamed:name];
		if (image != nil){
			[arr addObject:image];
		}
		else {
			NSLog(@"Image is NIL, name is %@", name);
		}

	}
	
	self.iconArray = arr;	
	self.iconNameArray = nameArray;
	[arr release];
}

- (void)dealloc
{
	[iconArray release];
	[selectedImageName release];
	[iconNameArray release];
	[delegate release];
	[super dealloc];
}

- (void)resetSelectedImage
{
	if (self.selectedImageName != nil){
		[self.selectedImageName release];
		self.selectedImageName = nil;
	}
}

@end
