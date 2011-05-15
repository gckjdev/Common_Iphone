//
//  ScheduleManager.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-31.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleTask.h"

@interface ScheduleManager : NSObject {

	NSThread				*scheduleThread;
	NSOperationQueue		*taskOperationQueue;
	NSMutableArray			*taskList;
	NSCondition				*taskListLock;
	BOOL					isStop;
	int						currentTaskID;
}

@property (nonatomic, retain) NSOperationQueue		*taskOperationQueue;
@property (nonatomic, retain) NSMutableArray		*taskList;
@property (nonatomic, retain) NSCondition			*taskListLock;
@property (nonatomic, assign) BOOL					isStop;
@property (nonatomic, retain) NSThread				*scheduleThread;

// for external usage
- (BOOL)addTask:(ScheduleTask*)task;
- (BOOL)deleteTask:(ScheduleTask*)task;
- (BOOL)stopAllTasks;
- (BOOL)startAllTasks;

// for internal usage
- (BOOL)isTaskRunNow:(ScheduleTask*)task;
- (BOOL)runTask:(ScheduleTask*)task;
- (BOOL)runTaskFinish:(ScheduleTask*)task;
- (void)scheduleThreadMain;
@end
