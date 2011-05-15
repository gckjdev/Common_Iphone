//
//  UIRectTextView.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-8.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UIRectTextView.h"


@implementation UIRectTextView

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 3.0);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
	
	CGContextAddRect(context, rect);
	CGContextDrawPath(context, kCGPathStroke);
}

@end
