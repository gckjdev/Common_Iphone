//
//  UIToolBarCell.m
//  Cells
//
//  Created by Peng Lingzhe on 6/8/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UIToolBarCell.h"

#define kHeightOfToolbarInCell		55
#define kSubViewFlag				324234234
#define kTextLabelTag				343089789
#define kTextLableIndent			9

@implementation UIToolBarCell

@synthesize buttonList, backgroundName, cellCollapseHeight, cellExpandHeight, newTextLabel;

+ (int)getToolbarHeight
{
	return kHeightOfToolbarInCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier backgroundImage:(NSString*)backgroundImage buttons:(NSMutableArray*)buttons
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		
		// set frame rect of tool bar
		
		int x = 0;
		int y = self.contentView.frame.size.height;
		int width = self.contentView.frame.size.width;
		int height = kHeightOfToolbarInCell;
		int heightWithoutToolbar = self.frame.size.height;
		
		NSLog(@"x=%d, y=%d, width=%d, height=%d, heightWithoutToolbar=%d", 
			  x, y, width, height, heightWithoutToolbar);
		
		CGRect rect = CGRectMake(x, y, width, height);
		
//		UIToolbar 
		
		
		// set background image
		UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImage]];
		imageView.frame = rect;
		imageView.tag = kSubViewFlag;		
		[self.contentView addSubview:imageView];
		[imageView release];
		
		// add button on top of image background
		self.buttonList = buttons;
		int buttonMaxWidth = (width) / [buttonList count];		
		CGRect buttonRect = rect;
		int startX = x;
		int startY = heightWithoutToolbar;		
		for (UIButton* button in buttonList){
			
			int buttonStartIndent = ( buttonMaxWidth - button.frame.size.width ) / 2;
			
			buttonRect.origin.x    = startX + buttonStartIndent;
			buttonRect.origin.y	   = startY + ( kHeightOfToolbarInCell - button.frame.size.height ) / 2;			
			buttonRect.size.width = button.frame.size.width;
			buttonRect.size.height = button.frame.size.height;						
			button.frame = buttonRect;
			button.tag   = kSubViewFlag;
			[self.contentView addSubview:button];
			
			startX += buttonMaxWidth;
			
		}
		
//		UIToolbar 
		
		CGRect textLabelRect = CGRectMake(kTextLableIndent, 0, width - kTextLableIndent * 6, heightWithoutToolbar);
		self.newTextLabel = [[UILabel alloc] initWithFrame:textLabelRect];
		newTextLabel.tag = kTextLabelTag;
		newTextLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:newTextLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return self;
}

- (void)updateCellRect:(int)heightOfCellWithoutToolbar
{
	CGRect rect = CGRectMake(0, 0, self.frame.size.width, heightOfCellWithoutToolbar + kHeightOfToolbarInCell);
	self.frame = rect;

	CGRect textLabelRect = self.newTextLabel.frame;
	textLabelRect.size.height = heightOfCellWithoutToolbar;
	self.newTextLabel.frame = textLabelRect;
	
	for (UIView *v in [self.contentView subviews]) {			
		if (v.tag == kSubViewFlag) {				
			v.hidden = NO;
			
			if ([v isKindOfClass:[UIImageView class]]){
				// it's background image
				CGRect rect = CGRectMake(0, heightOfCellWithoutToolbar, self.frame.size.width, kHeightOfToolbarInCell);
				v.frame = rect;
			}
			else {
				// it's button
				CGRect buttonRect = v.frame;
				buttonRect.origin.y	= heightOfCellWithoutToolbar + ( kHeightOfToolbarInCell - v.frame.size.height ) / 2;
				v.frame = buttonRect;
			}
			
		}						
	}   	
}


/*
- (int)getExtraHeight
{
	return cellExpandHeight - cellCollapseHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	static int kSubViewFlag = 223456;

	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
    [super setSelected:selected animated:animated];
	
	if (selected) {
		
		int x = self.contentView.frame.origin.x;
		
		// set frame rect
		CGRect rect = CGRectMake(x, cellCollapseHeight, self.contentView.frame.size.width - 1, [self getExtraHeight] - 2);

		// set background image
		UIImageView* image = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundName]] autorelease];
		image.frame = rect;
		image.tag = kSubViewFlag;		
		[self addSubview:image];
		
		if ([buttonList count] <= 0)
			return;
		
		// add button on top of image background
		int buttonMaxWidth = self.contentView.frame.size.width / [buttonList count];		
		CGRect buttonRect = rect;
		int startX = x;
		int startY = cellCollapseHeight;		
		for (UIButton* button in buttonList){
			
			int buttonStartIndent = ( buttonMaxWidth - button.frame.size.width ) / 2;
			
			buttonRect.origin.x    = startX + buttonStartIndent;
			buttonRect.origin.y	   = startY + ( [self getExtraHeight] - button.frame.size.height ) / 2;			
			buttonRect.size.width = button.frame.size.width;
			buttonRect.size.height = button.frame.size.height;						
			button.frame = buttonRect;
			button.tag   = kSubViewFlag;
			[self addSubview:button];
			
			startX += buttonMaxWidth;
		}
				
		return;		
		
	} else {
				
		// remove all extra expand subview
		for (UIView *v in [self subviews]) {			
			if (v.tag == kSubViewFlag) {				
				[v removeFromSuperview];
			}						
		}
		
		
	}
}
*/

- (void)dealloc {
	
	[newTextLabel release];
	[buttonList release];
	[backgroundName release];
    [super dealloc];
}

@end
