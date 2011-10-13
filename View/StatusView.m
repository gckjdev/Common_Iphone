//
//  StatusView.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatusView.h"


@implementation StatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

- (void)setStatusText:(NSString*)text vibrate:(BOOL)vibrate duration:(int)duration
{
    
}

#define DEFAULT_STATUS_DISPLAY_DURATION     10

- (void)setStatusText:(NSString*)text
{
    [self setStatusText:text vibrate:YES duration:DEFAULT_STATUS_DISPLAY_DURATION];
}

- (void)show
{
    
}

- (void)hide
{
    
}


@end
