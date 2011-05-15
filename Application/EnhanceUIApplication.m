//
//  EnhanceUIApplication.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-25.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "EnhanceUIApplication.h"


@implementation EnhanceUIApplication

@synthesize enableIdleTimer;
@synthesize idleTimer;
@synthesize idleTimeOut;

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
	
    // Only want to reset the timer on a Began touch or an Ended touch, to reduce the number of timer resets.
	if (enableIdleTimer){
		NSSet *allTouches = [event allTouches];
		if ([allTouches count] > 0) {
			// allTouches count only ever seems to be 1, so anyObject works here.
			UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
			if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded)
				[self resetIdleTimer];
		}
	}
}

- (void)stopIdleTimer {
	if (idleTimer){
		[idleTimer invalidate];
		self.idleTimer = nil;
	}
}

- (void)resetIdleTimer {
    if (idleTimer) {
        [idleTimer invalidate];
    }
	
	if (idleTimeOut <= 0){
		NSLog(@"<warning> idle time out is 0?");
		return;
	}
	
//	NSLog(@"<debug> reset idle timer");	
    self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:idleTimeOut target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
}

- (void)idleTimerExceeded {
//    NSLog(@"<debug> idle timer exceeded");
	
	// call app delegate methods here
	if ([self.delegate respondsToSelector:@selector(idleTimerExceeded)]){
		[self.delegate performSelector:@selector(idleTimerExceeded)];
	}

}

- (void)dealloc
{
	[idleTimer release];
	[super dealloc];
}

@end
