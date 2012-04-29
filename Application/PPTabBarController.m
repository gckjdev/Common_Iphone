//
//  Ivan_UITabBar.m
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PPTabBarController.h"
#import "UIBadgeView.h"
#import "UIButtonExt.h"
#import <QuartzCore/QuartzCore.h>

#define TAB_BADGEVIEW_OFFSET 120111101
#define TAB_BUTTON_FIX_WIDTH    27
#define TAB_BUTTON_FIX_HEIGHT   27

#define TITLE_TAG       820111031

@implementation PPTabBarController

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize slideBg;
@synthesize backgroundView;
@synthesize customTabBarView;
@synthesize selectedImageArray;
@synthesize buttonStyle;
@synthesize normalTextColor;
@synthesize selectTextColor;

@synthesize animation;
@synthesize backgroundColor;

- (void)setSelectedViewController:(UIViewController *)next
{
	if (self.animation == CubeTabBarControllerAnimationNone) {
		[super setSelectedViewController:next];
		return;
	}
    
	if (next == self.selectedViewController) {
		return;
	}
    
	self.view.userInteractionEnabled = NO;
    
	NSUInteger nextIndex = [self.viewControllers indexOfObject:next];
	UIViewController *current = self.selectedViewController;
    
	next.view.frame = current.view.frame;
    
	CGFloat halfWidth = current.view.bounds.size.width / 2.0;
	CGFloat duration = 0.7;
	CGFloat perspective = -1.0/1000.0;
    
	UIView *superView = current.view.superview;
	CATransformLayer *transformLayer = [[CATransformLayer alloc] init];
	transformLayer.frame = current.view.layer.bounds;
    
	[current.view removeFromSuperview];
	[transformLayer addSublayer:current.view.layer];
	[transformLayer addSublayer:next.view.layer];
	[superView.layer addSublayer:transformLayer];
    
	// let's be safe about setting stuff on view's we don't control
	UIColor *originalBackgroundColor = superView.backgroundColor;
	superView.backgroundColor = self.backgroundColor;
    
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	CATransform3D transform = CATransform3DIdentity;
    
	// yes, this switch has a bit of redundant code, but not sure yet if other animations will follow the same pattern
	switch (self.animation) {
		case CubeTabBarControllerAnimationOutside:
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			transform = CATransform3DRotate(transform, (nextIndex > self.selectedIndex) ? M_PI_2 : -M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			break;
		case CubeTabBarControllerAnimationInside:
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			transform = CATransform3DRotate(transform, (nextIndex > self.selectedIndex) ? -M_PI_2 : M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			break;
		default:
			break;
	}
    
	next.view.layer.transform = transform;
	[CATransaction commit];
    
	[CATransaction begin];
	[CATransaction setCompletionBlock:^(void) {
		[next.view.layer removeFromSuperlayer];
		next.view.layer.transform = CATransform3DIdentity;
		[current.view.layer removeFromSuperlayer];
		superView.backgroundColor = originalBackgroundColor;
		[superView addSubview:current.view];
		[transformLayer removeFromSuperlayer];
		[super setSelectedViewController:next];
		self.view.userInteractionEnabled = YES;
	}];
    
	CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
	transform = CATransform3DIdentity;
	transform.m34 = perspective;
	transformAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
    
	transform = CATransform3DIdentity;
	transform.m34 = perspective;
	switch (self.animation) {
		case CubeTabBarControllerAnimationOutside:
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			transform = CATransform3DRotate(transform, (nextIndex > self.selectedIndex) ? -M_PI_2 : M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			break;
		case CubeTabBarControllerAnimationInside:
			transform = CATransform3DTranslate(transform, 0, 0, halfWidth);
			transform = CATransform3DRotate(transform, (nextIndex > self.selectedIndex) ? M_PI_2 : -M_PI_2, 0, 1, 0);
			transform = CATransform3DTranslate(transform, 0, 0, -halfWidth);
			break;
		default:
			break;
	}
    
	transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
    
	transformAnimation.duration = duration;
    
	[transformLayer addAnimation:transformAnimation forKey:@"rotate"];
	transformLayer.transform = transform;
    
	[CATransaction commit];
}

- (void)viewDidLoad
{    
	[self hideRealTabBar];
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
        
    if (self.normalTextColor == nil)
        self.normalTextColor = [UIColor whiteColor];
    
    if (self.selectTextColor == nil)
        self.selectTextColor = [UIColor whiteColor];
    
	[self customTabBar];

    [super viewDidAppear:animated];
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

- (void)setBarBackground:(NSString*)backgroundImageName
{
    UIImage* image = [UIImage imageNamed:backgroundImageName];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];    
    self.backgroundView = imageView;
    self.backgroundView.frame = self.tabBar.bounds;
    [imageView release];
}

- (void)setButtonImage:(UIButton*)button image:(UIImage*)image
{
    if (image != nil){
        if (buttonStyle == TAB_BUTTON_STYLE_FILL)
            [button setBackgroundImage:image forState:UIControlStateNormal]; 
        else
            [button setImage:image forState:UIControlStateNormal];
    }
}

- (void)setButtonTitle:(UIButton*)button title:(NSString*)title
{
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];    
    
    // adjust title position
    if (buttonStyle == TAB_BUTTON_STYLE_FILL){
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    }
    else{
        [button centerImageAndTitle:1.0f];
    }
}

- (void)customTabBar{
    
    if (customTabBarView != nil){
        [self selectedTab:[self.buttons objectAtIndex:self.selectedIndex]];
        return;
    }
    
    // init
    customTabBarView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    
    // set background
    customTabBarView.backgroundColor = [UIColor clearColor];
    [customTabBarView addSubview:backgroundView];
    
	// create buttons
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    
    // set button width & height
    float WIDTH;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		WIDTH = 320.0;
	}
	else
	{
        WIDTH = 768.0;
    }
	double _width = WIDTH / viewCount;
	double _height = self.tabBar.frame.size.height;
    
	for (int i = 0; i < viewCount; i++) {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
		btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(i*_width, 0, _width, _height);
        
        [self setButtonImage:btn image:v.tabBarItem.image];
        [self setButtonTitle:btn title:v.tabBarItem.title];
        
        // add badge view
        if ([v.tabBarItem.badgeValue length] > 0){
            UIBadgeView *badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(40, 0, 30, 20)];
            badgeView.badgeString = v.tabBarItem.badgeValue;
            badgeView.badgeColor = [UIColor redColor];
            badgeView.tag = btn.tag + TAB_BADGEVIEW_OFFSET;
            [btn addSubview:badgeView];
            [badgeView release];
        }
        
		[self.buttons addObject:btn];
		[customTabBarView addSubview:btn];
	}
    
//	[customTabBarView addSubview:slideBg];
	[self.view insertSubview:customTabBarView atIndex:0];
    [self.view bringSubviewToFront:customTabBarView];

	[self selectedTab:[self.buttons objectAtIndex:self.selectedIndex]];

}

- (void)selectedTab:(UIButton *)button{

    // set new selected index
	self.currentSelectedIndex = button.tag;
    
    // update tab bar image for all buttons
    int i=0;
    for (UIButton* b in buttons){
        UIImage* image = nil;
        if (self.currentSelectedIndex == b.tag) {		
            NSString* imageName = [selectedImageArray objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            
            // set text color
            [b setTitleColor:self.selectTextColor forState:UIControlStateNormal];
        }
        else{
            UIViewController* v = [self.viewControllers objectAtIndex:i];
            image = v.tabBarItem.image;

            // set text color
            [b setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        }

        [self setButtonImage:b image:image];
        
        i++;
    }
            
    // activate normal tab bar controller
//    self.selectedViewController = [self.viewControllers objectAtIndex:self.currentSelectedIndex];
//    UIViewController* next = [self.viewControllers objectAtIndex:self.currentSelectedIndex];
//    [UIView transitionFromView:self.view 
//                        toView:next.view
//                      duration:1 /*or whatever time you want*/ 
//                       options:UIViewAnimationOptionTransitionFlipFromLeft /*specify your animation transition here, they are found in the UIView documentation*/ 
//                    completion:^(BOOL finished) {
//                        if (finished) {
//                        }
//                    }];
    self.selectedIndex = self.currentSelectedIndex;

//    [self.view bringSubviewToFront:customTabBarView];

    // animation for slide tab bar background
//	[self performSelector:@selector(slideTabBg:) withObject:button];
}

- (void)setTextColor:(UIColor*)normalTextColorValue selectTextColor:(UIColor*)selectTextColorValue
{
    self.selectTextColor = selectTextColorValue;
    self.normalTextColor = normalTextColorValue;
}

- (void)slideTabBg:(UIButton *)btn{
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:0.20];  
	[UIView setAnimationDelegate:self];
	slideBg.frame = btn.frame;
	[UIView commitAnimations];
}

- (void) dealloc{
    [backgroundColor release];
    [selectTextColor release];
    [normalTextColor release];
    [selectedImageArray release];
    [backgroundView release];
	[slideBg release];
	[buttons release];
    [customTabBarView release];
	[super dealloc];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
    else
        return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
- (void)setBadgeValue:(NSString *)value buttonTag:(NSInteger)tag
{
    for (UIButton* b in buttons) {
        if (b.tag == tag) {
            UIBadgeView *view = (UIBadgeView*)[b viewWithTag:(tag + TAB_BADGEVIEW_OFFSET)];
            if (view == nil) {
                view = [[UIBadgeView alloc] initWithFrame:CGRectMake(40, 0, 30, 20)];
                view.tag = tag + TAB_BADGEVIEW_OFFSET;
                [view setBadgeString:value];
                view.badgeColor = [UIColor redColor];
                [b addSubview:view];
                [view release];
            } else {
                [view setBadgeString:value];
            }
            if ([value intValue] == 0) {
                [view setHidden:YES];
            } else {
                [view setHidden:NO];
            }
            
        } 
    }
}
@end
