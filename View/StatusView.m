//
//  StatusView.m
//  FootballScore
//
//  Created by qqn_pipi on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatusView.h"

#define STATUS_VIEW_TEXT_TAG                20
#define DEFAULT_STATUS_DISPLAY_DURATION     10
#define STATUS_VIEW_ANIMATION_DURATION      0.5

StatusView *globalStatusView;

@implementation StatusView
@synthesize timer;
@synthesize statusWindow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        statusWindow = [[UIWindow alloc] init];
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
    [timer release];
    [statusWindow release];
    [super dealloc];
}

- (void)setStatusText:(NSString*)text vibrate:(BOOL)vibrate duration:(int)duration
{
    
}

- (void)setStatusText:(NSString*)text
{
    [self setStatusText:text vibrate:YES duration:DEFAULT_STATUS_DISPLAY_DURATION];
}

- (void)showStatusWithText:(NSString*)text 
                vibrate:(BOOL)vibrate 
               duration:(int)duration

{

    CGRect frame = CGRectMake(0, -20, 320, 20);
    
    [statusWindow setFrame:frame];
    [statusWindow setBackgroundColor:[UIColor blackColor]];
    [statusWindow setWindowLevel:UIWindowLevelStatusBar];
    [statusWindow makeKeyAndVisible];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    frame.origin.y += 20;
    [statusWindow setFrame:frame];
    [UIView commitAnimations];
    
    

    UIView *view = [statusWindow viewWithTag:STATUS_VIEW_TEXT_TAG];
    if (view) {
        UILabel *label = (UILabel*)view;
        label.text = text;
    }
    else {
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setFrame:CGRectMake(10, 0, 100, 20)];
        [label setTag:STATUS_VIEW_TEXT_TAG];
        [statusWindow addSubview:label];
        [label release];
    }
    if (vibrate) {
        //vibrate
    }

    [self.timer invalidate];
    self.timer = [[NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(didHideStatusText) userInfo:nil repeats:NO] retain];
    
}

- (void)didHideStatusText
{
    CGRect frame = CGRectMake(0, 0, 320, 20);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:STATUS_VIEW_ANIMATION_DURATION];
    frame.origin.y -= 20;
    [globalStatusView.statusWindow setFrame:frame];
    [UIView commitAnimations];
}

+ (void)showtStatusText:(NSString*)text 
                vibrate:(BOOL)vibrate 
               duration:(int)duration
{
    
    if (globalStatusView == nil){
        globalStatusView = [[StatusView alloc] init];
    }
    
    [globalStatusView showStatusWithText:text vibrate:vibrate duration:duration];
    
    
}

+ (void)hideStatusText
{
    [globalStatusView didHideStatusText];
}    

@end
