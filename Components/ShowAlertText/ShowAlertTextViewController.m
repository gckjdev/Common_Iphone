//
//  ShowAlertTextViewController.m
//  FootballScore
//
//  Created by haodong qiu on 11-11-22.
//  Copyright (c) 2011年 orange. All rights reserved.
//

#import "ShowAlertTextViewController.h"
#import "UIView+TKCategory.h"

#define SHOW_ALERT_TEXT_INTERVAL 2

ShowAlertTextViewController *globalShowAlertTextViewController;

@implementation ShowAlertTextView

- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithWhite:0 alpha:0.8] set];
	[UIView drawRoundRectangleInRect:rect withRadius:10];
	[[UIColor whiteColor] set];
//	[_text drawInRect:_messageRect withFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	
//	CGRect r = CGRectZero;
//	r.origin.y = 15;
//	r.origin.x = (rect.size.width-_image.size.width)/2;
//	r.size = _image.size;
//	
//	[_image drawInRect:r];
}

@end

@implementation ShowAlertTextViewController

@synthesize showTimer;
@synthesize message;
@synthesize messageLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self updateViewByMessage:self.message];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)removeFromSuperView
{
    if (self.view.superview){
        [self.view removeFromSuperview];
    }
}

+ (void) show:(UIView*)superView message:(NSString*)message
{
    if (globalShowAlertTextViewController == nil)
    {
        globalShowAlertTextViewController = [[ShowAlertTextViewController alloc] init];
        
        CGRect rect = globalShowAlertTextViewController.view.bounds;
        rect.origin = CGPointMake(100, 150);
        globalShowAlertTextViewController.view.frame = rect;
    }
    
    [globalShowAlertTextViewController removeFromSuperView];
    
    [superView addSubview:globalShowAlertTextViewController.view];
    
    [globalShowAlertTextViewController updateViewByMessage:message];
    
    [globalShowAlertTextViewController createHideTimer];

}

- (void)updateViewByMessage:(NSString*)newMessage
{
    self.message = newMessage;
    self.messageLabel.text = self.message;
}

- (void)createHideTimer
{
    [showTimer invalidate];
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:SHOW_ALERT_TEXT_INTERVAL 
                                                      target:self
                                                    selector:@selector(cancelDisplay) 
                                                    userInfo:nil 
                                                     repeats:NO];
}

- (void)cancelDisplay
{
    [self removeFromSuperView];
}


- (void)dealloc {
    [showTimer release];
    [message release];
    [messageLabel release];
    [super dealloc];
}
@end
