//
//  UINavigationBarExt.h
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-13.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

void GlobalSetNavBarBackground(NSString* imageName);
void clearNavBarBackground();
void activateNavBarBackground();
NSString* GlobalGetNavBarBackground();

@interface UINavigationBar (UINavigationBarExt)

- (void)stopTimer;
- (void)startTimer;
- (void)setBackgroundName:(NSArray*)imageArray;
- (NSArray*)getBackgroundName;

@end
