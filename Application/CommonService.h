//
//  CommonService.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonService : NSObject {
    dispatch_queue_t  workingQueue;
    
    NSMutableDictionary*     workingQueueDict;    
    NSMutableDictionary*     workingQueueOperationDict;
}

- (dispatch_queue_t)getQueue:(NSString*)key;
- (NSOperationQueue*)getOperationQueue:(NSString*)key;

@end
