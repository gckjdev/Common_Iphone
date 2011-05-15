//
//  EnhanceUIApplication.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-25.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IdleTimerDelegate <NSObject>

- (void)idleTimerExceeded;

@end


@interface EnhanceUIApplication : UIApplication {

	BOOL		enableIdleTimer;
	int			idleTimeOut;
	NSTimer		*idleTimer;
}

@property (nonatomic, assign) BOOL		enableIdleTimer;
@property (nonatomic, retain) NSTimer	*idleTimer;
@property (nonatomic, assign) int		idleTimeOut;

- (void)resetIdleTimer;
- (void)stopIdleTimer;

@end
