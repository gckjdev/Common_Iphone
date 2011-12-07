//
//  UIButtonExt.m
//  Test
//
//  Created by Peng Lingzhe on 5/21/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UIButtonExt.h"


@implementation UIButton (UIButtonExt)

- (void)setBackgroundImage:(UIImage*)image
{
	CGRect rect;
	rect	   = self.frame;	
	rect.size  = image.size;			// set button size as image size
	self.frame = rect;
	
	[self setBackgroundImage:image forState:UIControlStateNormal];	
}

- (void)setBackgroundImageByName:(NSString*)imageName
{
	[self setBackgroundImage:[UIImage imageNamed:imageName]];
}


- (void)centerImageAndTitle:(float)spacing
{    
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                                  - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                                  0.0, - imageSize.width - 5.0, - (totalHeight - titleSize.height), 0.0);    
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

@end
