//
//  StatusView.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusView : UIView {
    
    UIWindow    *statusWindow;
    NSTimer     *timer;
}


- (void)showStatusWithText:(NSString*)text 
                   vibrate:(BOOL)vibrate 
                  duration:(int)duration;
- (void)didHideStatusText;
- (void)setStatusText:(NSString*)text vibrate:(BOOL)vibrate duration:(int)duration;
- (void)setStatusText:(NSString*)text;

+ (void)showtStatusText:(NSString*)text 
                vibrate:(BOOL)vibrate 
               duration:(int)duration;
+ (void)hideStatusText;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIWindow *statusWindow;


@end
