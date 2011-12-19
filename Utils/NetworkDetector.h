//
//  NetworkDetector.h
//  FootballScore
//
//  Created by  on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkDetector : NSObject
{
    NSTimer *_timer;
    NSString *_errorMessage;
    NSTimeInterval _interval;
    NetworkStatus _lastNetworkStatus;
}

@property(nonatomic, copy) NSString *errorMessage;
@property(nonatomic, assign) NSTimeInterval interval;

- (id)initWithErrorMsg:(NSString *)msg detectInterval:(NSTimeInterval) interval;
- (void) start;
- (void) stop;
@end
