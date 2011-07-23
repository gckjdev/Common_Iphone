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
    return self;
}

- (void)dealloc
{
    dispatch_release(workingQueue);
    workingQueue = NULL;
    
    [super dealloc];
}

@end
