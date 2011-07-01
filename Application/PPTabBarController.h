//
//  Ivan_UITabBar.h
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PPTabBarController : UITabBarController {
	NSMutableArray *buttons;
	int currentSelectedIndex;
	UIImageView *slideBg;    
}
@property (nonatomic, assign) int				currentSelectedIndex;

@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic,retain) UIImageView *slideBg;

// only for internal usage
- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;

@end
