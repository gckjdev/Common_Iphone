//
//  ScheduleTask.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-31.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "ScheduleTask.h"
#import "ScheduleManager.h"

@implementation ScheduleTask

@synthesize interval;
@synthesize isRunInMainThread;
@synthesize isRepeat;
@synthesize manager;
@synthesize isRunning;
@synthesize lastRunDate;
@synthesize runTimes;
@synthesize taskLock;
@synthesize taskID;

- (id)initWithInterval:(int)intervalVal isRunInMainThread:(BOOL)isRunInMainThreadVal isRepeat:(BOOL)isRepeatVal
{
	if (self = [super init]){
		self.interval = intervalVal;
		self.isRunInMainThread = isRunInMainThreadVal;
		self.isRepeat = isRepeatVal;
		self.isRunning = NO;
		self.lastRunDate = nil;
		self.taskLock = [[NSCondition alloc] init];
		self.runTimes = 0;
	}
	
	return self;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"taskID(%d), interval(%d), isRunInMainThread(%d), isRepeat(%d), lastRunDate(%@), runTimes(%d)",
			taskID, interval, isRunInMainThread, isRepeat, [lastRunDate description], runTimes];
}

- (void)dealloc
{
	[taskLock release];
	[manager release];
	[lastRunDate release];
	[super dealloc];
}

- (void)lock
{
	[taskLock lock];
}

- (void)unlock
{
	[taskLock unlock];
}

- (void)taskMain
{
	NSLog(@"Run task: default action");
}

- (void)main
{
	[self taskMain];
	[manager runTaskFinish:self];
}

- (BOOL)canRun
{
	if (isRepeat == NO && runTimes > 0)
		return NO;
	
	if (lastRunDate == nil)
		return YES;
	
	NSDate* currentDate = [NSDate date];
	if ([currentDate timeIntervalSinceDate:lastRunDate] >= interval)
		return YES;
	else {
		return NO;
	}

}

@end
