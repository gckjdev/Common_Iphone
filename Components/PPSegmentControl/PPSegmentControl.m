//
//  PPSegmentControl.m
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPSegmentControl.h"


@implementation PPSegmentControl

@synthesize clickActionBlock;
@synthesize selectedSegmentIndex;

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

- (id)initWithItems:(NSArray*)titleArray defaultSelectIndex:(int)defaultSelectIndex
{
    self = [super init];
    return self;
}

- (void)setClickAction:(id)delegate actionBlock:(PPSegmentControlActionBlock)block
{
    
}

- (NSString*)titleForSegmentAtIndex
{
    return nil;
}

- (void)setBackgroundImage:(NSString*)imageName
{
    
}

- (void)setSelectedBackgroundImage:(NSString*)imageName
{
    
}

- (void)selectIndex:(int)index
{
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
