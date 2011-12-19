//
//  NetworkDetector.m
//  FootballScore
//
//  Created by  on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NetworkDetector.h"
#import "UIUtils.h"

@implementation NetworkDetector
@synthesize interval = _interval;
@synthesize errorMessage = _errorMessage;


- (id)initWithErrorMsg:(NSString *)msg detectInterval:(NSTimeInterval) interval
{
    self = [super init];
    if (self) {
        self.interval = interval;
        self.errorMessage = msg;
        _lastNetworkStatus = 1;
    }
    return self;
}

- (void)detectNetwork
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async(queue, ^{
		NSLog(@"<NetworkDetector:detectNetwork> starting...");
        Reachability* r = [Reachability reachabilityForInternetConnection];
		NetworkStatus status = [r currentReachabilityStatus];
		NSLog(@"<NetworkDetector:detectNetwork>: status = %d", status);
		if (status == NotReachable && _lastNetworkStatus != NotReachable){
			dispatch_async(dispatch_get_main_queue(), ^{
				[UIUtils alertWithTitle:@"网络连接失效" msg:_errorMessage];
			});
		}
        _lastNetworkStatus = status;
	});
}

- (void) start
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(detectNetwork) userInfo:nil repeats:YES];
}
- (void) stop
{
    [_timer invalidate];
    _timer = nil;
}


-(void)dealloc
{
    [_errorMessage release];
    [super dealloc];
}
@end
