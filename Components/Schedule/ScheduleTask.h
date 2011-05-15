//
//  ScheduleTask.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-31.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScheduleManager;

@interface ScheduleTask : NSOperation {

	int					taskID;				
	int					interval;				// seconds
	BOOL				isRunInMainThread;
	BOOL				isRepeat;				
	ScheduleManager		*manager;
	NSCondition			*taskLock;
	
	// runtime information
	NSDate				*lastRunDate;
	BOOL				isRunning;
	int					runTimes;
}

@property (nonatomic, assign) int				taskID;	
@property (nonatomic, assign) int				interval;				// seconds
@property (nonatomic, assign) BOOL				isRunInMainThread;
@property (nonatomic, assign) BOOL				isRepeat;				
@property (nonatomic, retain) ScheduleManager	*manager;

@property (nonatomic, retain) NSDate			*lastRunDate;
@property (nonatomic, assign) BOOL				isRunning;
@property (nonatomic, retain) NSCondition		*taskLock;
@property (nonatomic, assign) int				runTimes;


- (id)initWithInterval:(int)intervalVal isRunInMainThread:(BOOL)isRunInMainThreadVal isRepeat:(BOOL)isRepeatVal;
- (void)taskMain;
- (void)main;
- (void)lock;
- (void)unlock;
- (BOOL)canRun;

@end
