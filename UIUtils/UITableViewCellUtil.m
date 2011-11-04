//
//  UITableViewCellUtil.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UITableViewCellUtil.h"
#import "UICustomeBackGroundView.h"
#import "UICheckAndDetailView.h"
#import "UIBarButtonItemExt.h"
#import "UIViewUtils.h"
#import "UIImageUtil.h"

@implementation UITableViewCell (UITableViewCellUtil)

- (void)setBlueBlackBackground:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
	
	CustomCellBackgroundView *bgView = [[[CustomCellBackgroundView alloc] initWithFrame:self.frame] autorelease];
	
	bgView.position = CustomCellBackgroundViewPositionMiddle;

	bgView.borderColor = [UIColor clearColor];

	self.backgroundColor = [UIColor clearColor];
	
	tableView.backgroundColor = [UIColor clearColor];
	
	if ( [indexPath row] % 2 == 0 ){		
		bgView.fillColor = [UIColor clearColor];
	}
	else {
		bgView.fillColor = [UIColor colorWithRed:0.90f green:0.95f blue:1.0f alpha:1.0f];		
	}

	self.backgroundView = bgView;
}

- (void)addCheckAndDetailView:(id)delegate
{
	CGRect frame = CGRectMake(280, self.contentView.frame.origin.y + 10, 50, 40);
	UICheckAndDetailView* cdView = [[[UICheckAndDetailView alloc] initWithFrame:frame] autorelease];		
	cdView.delegate  = delegate;
	self.accessoryView = cdView;	
}

- (UICheckAndDetailView*)getCheckAndDetailView
{
	if ([self.accessoryView isKindOfClass:[UICheckAndDetailView class]]){
		return (UICheckAndDetailView*)self.accessoryView;
	}
	else {
		return nil;
	}

}

- (void)setCellBackgroundForRow:(int)row 
                       rowCount:(int)count 
                singleCellImage:(NSString*)singleCellImageName
                 firstCellImage:(NSString*)firstCellImageName
                middleCellImage:(NSString*)middleCellImageName
                  lastCellImage:(NSString*)lastCellImageName
                      cellWidth:(int)cellWidth
{	    
	// set background image
	if (row == 0 && count == 1){
        UIImageView* singleCellImageView = [UIImage strectchableImageView:singleCellImageName viewWidth:cellWidth];
//        singleCellImageView.contentMode = UIViewContentMode;
        [self setBackgroundView:singleCellImageView];
    }
	else if (row == 0){
        UIImageView* firstCellImageView  = [UIImage strectchableImageView:firstCellImageName viewWidth:cellWidth];
//        UIView* view = [[UIView alloc] init];
//        [view addSubview:firstCellImageView];
//        CGRect frame = self.contentView.frame;
//        frame.size.width =         
//        view.frame = CGRectMake(100, 0, cellWidth, firstCellImageView.image.size.height);
        [self setBackgroundView:firstCellImageView];
//        [view release];
    }
	else if (row == (count - 1)){
        UIImageView* lastCellImageView   = [UIImage strectchableImageView:lastCellImageName viewWidth:cellWidth];
//        lastCellImageView.contentMode = UIViewContentModeCenter;
        [self setBackgroundView:lastCellImageView];
    }
	else{
        UIImageView* middleCellImageView = [UIImage strectchableImageView:middleCellImageName viewWidth:cellWidth];
//        middleCellImageView.contentMode = UIViewContentModeCenter;
        [self setBackgroundView:middleCellImageView];
    }
}

- (void)setBackgroundImage:(UIImage*)image
{
	/*
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    self.backgroundView = imageView;
    [imageView release];
	
	self.contentView.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
	*/
	
	[self setBackgroundImage:image alpha:1.0f];
    
}

- (void)setBackgroundImageByName:(NSString*)imageName
{
    [self setBackgroundImage:[UIImage imageNamed:imageName]];
}

- (void)setBackgroundImageByName:(NSString*)imageName alpha:(float)alpha
{
	[self setBackgroundImage:[UIImage imageNamed:imageName] alpha:alpha];
}

- (void)setBackgroundImage:(UIImage*)image alpha:(float)alpha
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
	imageView.alpha = alpha;
    self.backgroundView = imageView;
    [imageView release];
	
	self.contentView.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];	
}

- (void)setBackgroundImageByView:(UIImageView*)imageView
{
	UIImageView* backgroundView = [[UIImageView alloc] initWithImage:imageView.image];	
    backgroundView.contentMode = UIViewContentModeCenter;
	backgroundView.alpha = 1.0f;

    self.backgroundView = backgroundView;
	[backgroundView release];
	
	self.contentView.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];		
}

#define kTableViewCellToolbarTag 1998

- (UIToolbar*)addToolbar:(NSArray*)barButtons autoAddSpaceButton:(BOOL)autoAddSpaceButton
{	
		UIView* view = [self.contentView viewWithTag:kTableViewCellToolbarTag];
		if (view != nil){
			// tool bar exist, then do nothing
			return (UIToolbar*)view;
		}
		
		// set cell frame
//		CGRect newFrame = self.contentView.frame;
//		newFrame.size.height += kToolBarHeight;
//		self.contentView.frame = newFrame;

		// set toolbar frame
//		CGRect toolbarFrame = CGRectMake(0, self.contentView.frame.size.height, self.contentView.frame.size.width, kToolBarHeight);					
		CGRect toolbarFrame = CGRectMake(0, self.contentView.bounds.size.height, self.contentView.frame.size.width, kToolBarHeight);					
		UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
		
		toolbar.tag = kTableViewCellToolbarTag;
		[self.contentView addSubview:toolbar];
	
		// add bar buttons
		if (autoAddSpaceButton){

			UIBarItem* spaceButton = [UIBarButtonItem createSpaceBarButtonItem];
			
			NSMutableArray* array = [[NSMutableArray alloc] init];
			for (NSObject* button in barButtons){
				[array addObject:button];
				if (button != [barButtons lastObject]){
					[array addObject:spaceButton];
				}
			}
			toolbar.items = array;
			[array release];
			
		}
		else {
			toolbar.items = barButtons;
		}		
		
		return toolbar;
}

- (void)removeToolbar
{
	UIView* view = [self.contentView viewWithTag:kTableViewCellToolbarTag];
	if (view != nil){
		[view removeFromSuperview];
		
		// change frame
//		CGRect newFrame = self.contentView.frame;
//		newFrame.size.height -= kToolBarHeight;
//		self.contentView.frame = newFrame;			
	}		
	return;
}

@end
