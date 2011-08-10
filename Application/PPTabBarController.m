//
//  Ivan_UITabBar.m
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PPTabBarController.h"
#import "UIBadgeView.h"

@implementation PPTabBarController

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize slideBg;

- (void)viewDidAppear:(BOOL)animated{
	slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide"]];
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

- (void)customTabBar{
	UIView *tabBarBackGroundView = [[UIView alloc] initWithFrame:self.tabBar.frame];
	tabBarBackGroundView.backgroundColor = [UIColor grayColor];
	//创建按钮
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
	double _width = 320 / viewCount;
//	NSLog(@"%d",viewCount);
	double _height = self.tabBar.frame.size.height;
	for (int i = 0; i < viewCount; i++) {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.frame = CGRectMake(i*_width, 0, _width, _height);
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
		btn.tag = i;
//		NSLog(@"%@",v.tabBarItem.image);
		[btn setBackgroundImage:v.tabBarItem.image forState:UIControlStateNormal];
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _height-20, _width, _height-30)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.text = v.tabBarItem.title;
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:11];
		[btn addSubview:titleLabel];
		[titleLabel release];
        
        UIBadgeView *badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        badgeView.badgeString = @"12"; //v.tabBarItem.badgeValue;
        badgeView.badgeColor = [UIColor redColor];
        [btn addSubview:badgeView];
        [badgeView release];
        
		[self.buttons addObject:btn];
		[tabBarBackGroundView addSubview:btn];
	}
	//[self.view addSubview:tabBarBackGroundView];
	[tabBarBackGroundView addSubview:slideBg];
	[self.view insertSubview:tabBarBackGroundView atIndex:0];
	[tabBarBackGroundView release];
	[self selectedTab:[self.buttons objectAtIndex:0]];
}

- (void)selectedTab:(UIButton *)button{
	if (self.currentSelectedIndex == button.tag) {
		
	}
	self.currentSelectedIndex = button.tag;
	self.selectedIndex = self.currentSelectedIndex;
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
	[slideBg release];
	[buttons release];
	[super dealloc];
}


@end
