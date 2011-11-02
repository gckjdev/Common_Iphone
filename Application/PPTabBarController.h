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
    
    UIView* customTabBarView;

}
@property (nonatomic, assign) int				currentSelectedIndex;

@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic,retain) UIImageView *slideBg;
@property (nonatomic,retain) UIImageView *backgroundView;
@property (nonatomic,retain) UIView* customTabBarView;
@property (nonatomic,retain) NSArray* selectedImageArray;

// for external call
- (void)setBarBackground:(NSString*)backgroundImageName;

// only for internal usage
- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void)setBadgeValue:(NSString*)value buttonTag:(NSInteger)tag;

@end
