//
//  UIBarButtonItemExt.h
//  three20test
//
//  Created by qqn_pipi on 10-5-29.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInfoLeftBack		NSLocalizedString(@"Back", @"")

@interface UIBarButtonItem (UIBarButtonItemExt)

+ (UIButton *)getButtonWithTitle:(NSString*)title imageName:(NSString*)imageName target:(id)target action:(SEL)action;

- (void)enableCustomButton:(BOOL)value;

- (void)setTitleTextColor:(UIColor*)color;

+ (UIBarButtonItem*)createSpaceBarButtonItem;

@end

