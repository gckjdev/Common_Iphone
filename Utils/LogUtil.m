//
//  LogUtil.m
//  three20test
//
//  Created by qqn_pipi on 10-3-30.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "LogUtil.h"


@implementation LogUtil

+ (void)startLog:(NSString*)string
{
	NSLog(@"************************** Start %@ **************************", string);
}

+ (void)stopLog:(NSString*)string
{
	NSLog(@"************************** End %@ **************************", string);
}

@end
