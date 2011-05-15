//
//  ScheduleManagerTest.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-31.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "ScheduleManagerTest.h"
#import "ScheduleManager.h"
#import "ScheduleTask.h"

@implementation ScheduleManagerTest

+ (void)startTest
{
	ScheduleManager* manager = [[ScheduleManager alloc] init];
	ScheduleTask* task1 = [[ScheduleTask alloc] initWithInterval:3 isRunInMainThread:NO isRepeat:YES];
	ScheduleTask* task2 = [[ScheduleTask alloc] initWithInterval:5 isRunInMainThread:NO isRepeat:NO];
	
	[manager addTask:task1];
	[manager addTask:task2];

}

@end
