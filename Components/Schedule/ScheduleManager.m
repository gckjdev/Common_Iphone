//
//  ScheduleManager.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-31.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "ScheduleManager.h"


@implementation ScheduleManager

@synthesize taskList;
@synthesize taskOperationQueue;
@synthesize taskListLock;
@synthesize scheduleThread;
@synthesize isStop;

- (id)init
{
	if (self = [super init]){
		self.taskList = [[NSMutableArray alloc] init];
		self.taskOperationQueue = [[NSOperationQueue alloc] init];
		self.taskListLock = [[NSCondition alloc] init];
		self.scheduleThread = [[NSThread alloc] initWithTarget:self selector:@selector(scheduleThreadMain) object:nil];
		[self.scheduleThread start];

		currentTaskID = 0;
		isStop = NO;
	}
	
	return self;
}

- (void)dealloc
{
	[taskList release];
	[taskListLock release];
	[taskOperationQueue release];
	[scheduleThread release];
	[super dealloc];
}

// for external usage
- (BOOL)addTask:(ScheduleTask*)task
{
	[taskListLock lock];
	[task setManager:self];
	[task setTaskID:currentTaskID++];
	[taskList addObject:task];	
	
	NSLog(@"Task[%d] Added, task=%@", task.taskID, [task description]);		
	[taskListLock unlock];
	
	return YES;
}

- (BOOL)deleteTask:(ScheduleTask*)task
{
	NSLog(@"Task[%d] Delete", task.taskID);	
	
	[taskListLock lock];
	[taskList removeObject:task];
	[taskListLock unlock];

	return YES;
}

- (BOOL)stopAllTasks
{
	NSLog(@"stopAllTasks");

	[taskListLock lock];
	isStop = YES;
	[taskListLock unlock];

	return YES;
}

- (BOOL)startAllTasks
{
	NSLog(@"startAllTasks");
	
	[taskListLock lock];
	isStop = NO;
	[taskListLock unlock];

	return YES;
}

// for internal usage
- (BOOL)isTaskRunNow:(ScheduleTask*)task
{
	BOOL ret = NO;
	[task lock];
	ret = [task isRunning];
	[task unlock];	
	return ret;
}

- (BOOL)runTask:(ScheduleTask*)task
{
	
	[task lock];
	if (task.isRunning == NO && [task canRun] == YES){
		task.isRunning = YES;	
		task.runTimes ++;
		task.lastRunDate = [NSDate date];

//		NSLog(@"Task[%d] Run OK, task=%@", task.taskID, [task description]);	
		
		if (task.isRunInMainThread){
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[task main];
			}];
		}
		else{
			[taskOperationQueue addOperationWithBlock:^{
				[task main];
			}];
		}
	}
	else {
//		NSLog(@"Task[%d] Run Failure, task=%@", task.taskID, [task description]);			
	}

	[task unlock];		
	
	return YES;
}

- (BOOL)runTaskFinish:(ScheduleTask*)task
{
//	NSLog(@"Task[%d] Finish", task.taskID);
	
	[task lock];
	if (task.isRunning == YES){
		task.isRunning = NO;		
	}
	[task unlock];		
	
	return YES;
}

- (void)scheduleThreadMain
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	NSLog(@"Schedule thread start...");
	while (YES){
		
		[taskListLock lock];	
		if (isStop == NO){		
//			NSLog(@"Loop all tasks...");
			for (ScheduleTask* task in taskList){
				[self runTask:task];
			}		
//			NSLog(@"Loop all tasks finished...");
		}
		else {
			NSLog(@"Schedule stop, skip all tasks");
		}

		[taskListLock unlock];		
		[NSThread sleepForTimeInterval:1];
	}
	
	NSLog(@"Schedule thread stop");
	[pool release];

}

@end
