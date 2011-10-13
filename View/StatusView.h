//
//  StatusView.h
//  FootballScore
//
//  Created by qqn_pipi on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusView : UIView {
    
}

- (void)show;
- (void)hide;
- (void)setStatusText:(NSString*)text vibrate:(BOOL)vibrate duration:(int)duration;
- (void)setStatusText;

@end
