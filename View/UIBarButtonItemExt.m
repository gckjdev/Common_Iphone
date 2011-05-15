//
//  UIBarButtonItemExt.m
//  three20test
//
//  Created by qqn_pipi on 10-5-29.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIBarButtonItemExt.h"
#import "UIButtonExt.h"

#define kUIBarButtonItemCustomButton		19871977


@implementation UIBarButtonItem (UIBarButtonItemExt)

+ (UIButton *)getButtonWithTitle:(NSString*)title imageName:(NSString*)imageName target:(id)target action:(SEL)action
{
	UIButton* button = [[[UIButton alloc] init] autorelease];
	[button setBackgroundImageByName:imageName];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];	
	button.titleLabel.font = [UIFont boldSystemFontOfSize:12];	
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	button.tag = kUIBarButtonItemCustomButton;
	
	return button;
}

- (void)enableCustomButton:(BOOL)value
{
	if (self.customView != nil && [self.customView isKindOfClass:[UIButton class]]){
		UIButton* button = (UIButton*)self.customView;
		button.enabled = value;		
	}
}

- (void)setTitleTextColor:(UIColor*)color
{
	if (self.customView != nil && [self.customView isKindOfClass:[UIButton class]]){
		UIButton* button = (UIButton*)self.customView;
		[button setTitleColor:color forState:UIControlStateNormal];
	}
	
}

+ (UIBarButtonItem*)createSpaceBarButtonItem
{
	return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
	  UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];				
}

@end
