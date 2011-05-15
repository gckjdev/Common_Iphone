//
//  UINavigationItemExt.m
//  Redial
//
//  Created by Peng Lingzhe on 8/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UINavigationItemExt.h"


@implementation UINavigationItem (UINavigationItemExt)

- (void)setTitleViewWithLabel:(UILabel*)label
{
	self.titleView = label;
}

- (void)setRichTextTitleView:(NSString*)title textColor:(UIColor*)color font:(UIFont*)font
{
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];	
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;

	if (color != nil)
		label.textColor = color;
	if (font != nil)
		label.font = font;
	if (title != nil)
		label.text = title;
	
	[self setTitleViewWithLabel:label];
	[label release];
}

- (void)setTitleViewText:(NSString*)title
{
	UIView* view = self.titleView;
	if (view && [view isKindOfClass:[UILabel class]]){
		UILabel* label = (UILabel*)view;
		label.text = title;
	}
}

@end
