//
//  CommonService.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonService.h"


@implementation CommonService

- (id)init
{    
    self = [super init];    
    workingQueue = dispatch_queue_create("service queue", NULL);
    workingQueueDict = [[NSMutableDictionary alloc] init];
    workingQueueOperationDict = [[NSMutableDictionary alloc] init];
    return self;
}

- (NSOperationQueue*)getOperationQueue:(NSString*)key
{
    if (key == nil){
        NSLog(@"ERROR : Try to get operation queue but key is nil");
        return NULL;
    }
    
    NSOperationQueue *queue = [workingQueueOperationDict objectForKey:key];
    if (queue == nil){
        queue = [[NSOperationQueue alloc] init];
        [workingQueueOperationDict setObject:queue forKey:key];
        [queue release];
    }
    
    return queue;            
}

- (dispatch_queue_t)getQueue:(NSString*)key
{
    if (key == nil){
        NSLog(@"ERROR : Try to get working queue but key is nil");
        return NULL;
    }
    
    dispatch_queue_t queue = NULL;
    NSNumber* value = [workingQueueDict objectForKey:key];
    if (value == nil){
        queue = dispatch_queue_create([key UTF8String], NULL);
        [workingQueueDict setObject:[NSNumber numberWithLong:(long)queue] forKey:key];
    }
    else{
        queue = (dispatch_queue_t)[value longValue];
    }
    
    return queue;        
}

- (void)dealloc
{
    dispatch_release(workingQueue);
    workingQueue = NULL;

    // release queue
    NSArray* queues = [workingQueueDict allValues];
    for (NSNumber* queue in queues){
        dispatch_queue_t q = (dispatch_queue_t)[queue longValue];
        dispatch_release(q);
    }
    
    [super dealloc];
}

@end
