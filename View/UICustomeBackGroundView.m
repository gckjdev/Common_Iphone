//
//  CustomCellBackgroundView.m
//
//  Created by Mike Akers on 11/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UICustomeBackGroundView.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
								 float ovalWidth,float ovalHeight);

@implementation CustomCellBackgroundView
@synthesize borderColor, fillColor, position;

- (BOOL) isOpaque {
	return NO;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(c, [fillColor CGColor]);
	CGContextSetStrokeColorWithColor(c, [borderColor CGColor]);
	
	if (position == CustomCellBackgroundViewPositionTop) {
		CGContextFillRect(c, CGRectMake(0.0f, rect.size.height - 10.0f, rect.size.width, 10.0f));
		CGContextBeginPath(c);
		CGContextMoveToPoint(c, 0.0f, rect.size.height - 10.0f);
		CGContextAddLineToPoint(c, 0.0f, rect.size.height);
		CGContextAddLineToPoint(c, rect.size.width, rect.size.height);
		CGContextAddLineToPoint(c, rect.size.width, rect.size.height - 10.0f);
		CGContextStrokePath(c);
		CGContextClipToRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height - 10.0f));
	} else if (position == CustomCellBackgroundViewPositionBottom) {
		CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, 10.0f));
		CGContextBeginPath(c);
		CGContextMoveToPoint(c, 0.0f, 10.0f);
		CGContextAddLineToPoint(c, 0.0f, 0.0f);
		CGContextStrokePath(c);
		CGContextBeginPath(c);
		CGContextMoveToPoint(c, rect.size.width, 0.0f);
		CGContextAddLineToPoint(c, rect.size.width, 10.0f);
		CGContextStrokePath(c);
		CGContextClipToRect(c, CGRectMake(0.0f, 10.0f, rect.size.width, rect.size.height));
	} else if (position == CustomCellBackgroundViewPositionMiddle) {
		CGContextFillRect(c, rect);
		CGContextBeginPath(c);
		CGContextMoveToPoint(c, 0.0f, 0.0f);
		CGContextAddLineToPoint(c, 0.0f, rect.size.height);
		CGContextAddLineToPoint(c, rect.size.width, rect.size.height);
		CGContextAddLineToPoint(c, rect.size.width, 0.0f);
		CGContextStrokePath(c);
		return; // no need to bother drawing rounded corners, so we return
	}
	
	// At this point the clip rect is set to only draw the appropriate
	// corners, so we fill and stroke a rounded rect taking the entire rect
	
	CGContextBeginPath(c);
	addRoundedRectToPath(c, rect, 10.0f, 10.0f);
	CGContextFillPath(c);  
	
	CGContextSetLineWidth(c, 1);  
	CGContextBeginPath(c);
	addRoundedRectToPath(c, rect, 10.0f, 10.0f);  
	CGContextStrokePath(c);     
}


- (void)dealloc {
	[borderColor release];
	[fillColor release];
	[super dealloc];
}


@end

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
								 float ovalWidth,float ovalHeight)

{
	float fw, fh;
	
	if (ovalWidth == 0 || ovalHeight == 0) {// 1
		CGContextAddRect(context, rect);
		return;
	}
	
	CGContextSaveGState(context);// 2
	
	CGContextSetShouldAntialias(context, YES);
	CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
						   CGRectGetMinY(rect));
	CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
	fw = CGRectGetWidth (rect) / ovalWidth;// 5
	fh = CGRectGetHeight (rect) / ovalHeight;// 6
	
	CGContextMoveToPoint(context, fw, fh/2); // 7
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
	CGContextClosePath(context);// 12
	
	CGContextRestoreGState(context);// 13
}
