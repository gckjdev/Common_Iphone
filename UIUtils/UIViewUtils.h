//
//  UIViewUtils.h
//  three20test
//
//  Created by qqn_pipi on 10-3-19.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNavigationBarHeight		44
#define kToolBarHeight				44
#define kTabBarHeight				50
#define kStatusBarHeight			20
#define kSearchBarHeight			50
#define kKeyboadHeight              216

#define isRetina					([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
												CGSizeEqualToSize(CGSizeMake(640, 960), \
												[[UIScreen mainScreen] currentMode].size) : NO)

#define isIPad						(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kScreenWidth				(320)
#define kScreenHeight				(480)

#define activityViewTag				0x98751234

@interface UIView (UIViewUtils) 

- (void)setBackgroundImageView:(NSString *)imageName;
- (UIView *)findFirstResonder;

- (void)showActivityViewAtCenter;
- (void)hideActivityViewAtCenter;
- (UIActivityIndicatorView*)createActivityViewAtCenter:(UIActivityIndicatorViewStyle)style;
- (UIActivityIndicatorView*)getActivityViewAtCenter;



@end

@interface UISearchBar (UISearchBarUtils)

- (void)setSearchBarBackgroundByView:(UIImageView*)imageView;
- (void)setSearchBarBackgroundByImage:(NSString*)imageName;

@end