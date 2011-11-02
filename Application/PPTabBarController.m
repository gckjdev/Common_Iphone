//
//  Ivan_UITabBar.m
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PPTabBarController.h"
#import "UIBadgeView.h"

#define TAB_BADGEVIEW_OFFSET 120111101

@implementation PPTabBarController

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize slideBg;
@synthesize backgroundView;
@synthesize customTabBarView;
@synthesize selectedImageArray;

- (void)viewDidAppear:(BOOL)animated{
	[self hideRealTabBar];
	[self customTabBar];
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
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];    
    self.backgroundView = imageView;
    self.backgroundView.frame = self.tabBar.frame;
    [imageView release];
}

- (void)customTabBar{
    
    if (customTabBarView != nil){
        [self selectedTab:[self.buttons objectAtIndex:self.selectedIndex]];
        return;
    }
    
    // init
    customTabBarView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    
    // set background
    customTabBarView.backgroundColor = [UIColor grayColor];    
    [customTabBarView addSubview:backgroundView];
    
	// create buttons
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    
    // set button width & height
	double _width = 320 / viewCount;
	double _height = self.tabBar.frame.size.height;
    
	for (int i = 0; i < viewCount; i++) {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(i*_width, 0, _width, _height);
//        NSLog(@"button frame : %@", NSStringFromCGRect(btn.frame));

		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
		btn.tag = i;
                
        // set background
		[btn setBackgroundImage:v.tabBarItem.image forState:UIControlStateNormal];
        
        // add title label
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _height-20, _width, _height-30)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.text = v.tabBarItem.title;
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:10];
		[btn addSubview:titleLabel];
		[titleLabel release];
        
        // add badge view
        if ([v.tabBarItem.badgeValue length] > 0){
            UIBadgeView *badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
            badgeView.badgeString = v.tabBarItem.badgeValue;
            badgeView.badgeColor = [UIColor redColor];
            badgeView.tag = btn.tag + TAB_BADGEVIEW_OFFSET;
            [btn addSubview:badgeView];
            [badgeView release];
        }
        
		[self.buttons addObject:btn];
		[customTabBarView addSubview:btn];
	}
    
	[customTabBarView addSubview:slideBg];
	[self.view insertSubview:customTabBarView atIndex:0];

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
        }
        else{
            UIViewController* v = [self.viewControllers objectAtIndex:i];
            image = v.tabBarItem.image;
        }
        
        if (image != nil){
            [b setBackgroundImage:image forState:UIControlStateNormal]; 
        }
        
        i++;
    }
            
    // activate normal tab bar controller
	self.selectedIndex = self.currentSelectedIndex;
    
    // animation for slide tab bar background
	[self performSelector:@selector(slideTabBg:) withObject:button];
}


- (void)slideTabBg:(UIButton *)btn{
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:0.20];  
	[UIView setAnimationDelegate:self];
	slideBg.frame = btn.frame;
	[UIView commitAnimations];
}

- (void) dealloc{
    [selectedImageArray release];
    [backgroundView release];
	[slideBg release];
	[buttons release];
    [customTabBarView release];
	[super dealloc];
}

- (void)setBadgeValue:(NSString *)value buttonTag:(NSInteger)tag
{
    for (UIButton* b in buttons) {
        if (b.tag == tag) {
            UIBadgeView *view = [b viewWithTag:(tag + TAB_BADGEVIEW_OFFSET)];
            if (view == nil) {
                view = [[UIBadgeView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
                view.tag = tag + TAB_BADGEVIEW_OFFSET;
                [view setBadgeString:value];
                view.badgeColor = [UIColor redColor];
                [b addSubview:view];
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
