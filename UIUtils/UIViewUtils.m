//
//  UIViewUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-3-19.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIViewUtils.h"


@implementation UIView (UIViewUtils)

- (void)setBackgroundImageView:(NSString *)imageName
{
	int kBackgroundViewTag = 1024768;
	
	self.backgroundColor = [UIColor clearColor];
	
	CGRect frame = self.bounds;
	
	// create view
	UIImageView* bgview = [[UIImageView alloc] initWithFrame:frame];
	
	// set view tag
	bgview.tag = kBackgroundViewTag;
	
	// set image
	UIImage* image = [UIImage imageNamed:imageName];
//	image = [image stretchableImageWithLeftCapWidth:self.frame.size.width topCapHeight:self.frame.size.height];
	
	[bgview setImage:image];	
	
	// remove old bgview if it exists
	UIView* oldView = [self viewWithTag:kBackgroundViewTag];
	[oldView removeFromSuperview];
	
	// add to super view
	[self insertSubview:bgview atIndex:0];
	
	// release the bgview
	[bgview release];
}



- (UIView *)findFirstResonder
{
    if (self.isFirstResponder) {        
        return self;     
    }
	
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResonder];
		
        if (firstResponder != nil) {
			return firstResponder;
        }
    }
	
    return nil;
}


- (UIActivityIndicatorView*)createActivityViewAtCenter:(UIActivityIndicatorViewStyle)style
{
	static int size = 30;
	
	UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
	activityView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - size/2, [UIScreen mainScreen].bounds.size.height/2 - size*2, size, size);
	activityView.tag = activityViewTag;
	[self addSubview:activityView];
	[activityView release];
	
	return activityView;
}

- (UIActivityIndicatorView*)getActivityViewAtCenter
{
	UIView* view = [self viewWithTag:activityViewTag];
	if (view != nil && [view isKindOfClass:[UIActivityIndicatorView class]]){
		return (UIActivityIndicatorView*)view;
	}
	else {
		return nil;
	}
}

- (void)showActivityViewAtCenter
{
	UIActivityIndicatorView* activityView = [self getActivityViewAtCenter];
	if (activityView == nil){
		activityView = [self createActivityViewAtCenter:UIActivityIndicatorViewStyleWhite];
	}

	[activityView startAnimating];
}

- (void)hideActivityViewAtCenter
{
	UIActivityIndicatorView* activityView = [self getActivityViewAtCenter];
	if (activityView != nil){
		[activityView stopAnimating];
	}		
}


@end

@implementation UISearchBar (UISearchBarUtils)

- (void)setSearchBarBackgroundByImage:(NSString*)imageName
{
	// hide the search bar background
	UIView* segment=[self.subviews objectAtIndex:0];
	segment.hidden=YES;		
	
	//	UIView* bg=[searchBar.subviews objectAtIndex:1];
	//	bg.hidden=YES;	
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[imageView setImage:[UIImage imageNamed:imageName]];
	
	[self insertSubview:imageView atIndex:1];
//	[self sendSubviewToBack:imageView];
	
	[imageView release];
}

- (void)setSearchBarBackgroundByView:(UIImageView*)imageView
{
	// hide the search bar background
	UIView* segment=[self.subviews objectAtIndex:0];
	segment.hidden=YES;		

	//	UIView* bg=[searchBar.subviews objectAtIndex:1];
	//	bg.hidden=YES;	
	
	[self addSubview:imageView];
	[self sendSubviewToBack:imageView];
}

@end
