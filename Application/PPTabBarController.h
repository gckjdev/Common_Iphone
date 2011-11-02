//
//  Ivan_UITabBar.h
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TAB_BUTTON_STYLE {
    TAB_BUTTON_STYLE_FILL = 0,
    TAB_BUTTON_STYLE_ICON = 1
};

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
@property (nonatomic,assign) int buttonStyle;
@property (nonatomic,retain) UIColor* normalTextColor;
@property (nonatomic,retain) UIColor* selectTextColor;

// for external call
- (void)setBarBackground:(NSString*)backgroundImageName;

// only for internal usage
- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
- (void)setBadgeValue:(NSString*)value buttonTag:(NSInteger)tag;
- (void)setTextColor:(UIColor*)normalTextColor selectTextColor:(UIColor*)selectTextColor;

@end
