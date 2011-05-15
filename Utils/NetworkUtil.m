//
//  NetworkUtil.m
//  three20test
//
//  Created by qqn_pipi on 10-4-14.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "NetworkUtil.h"
#import "Reachability.h"

@implementation NetworkUtil

+ (BOOL) connectedToNetwork
{
	Reachability* reach1 = [Reachability reachabilityForInternetConnection];
//	Reachability* reach2 = [Reachability reachabilityForLocalWiFi];
	
	if ( [reach1 currentReachabilityStatus] == NotReachable ){
		return NO;
	}
	else {
		return YES;
	}

}

@end
