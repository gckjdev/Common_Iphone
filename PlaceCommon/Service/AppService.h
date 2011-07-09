//
//  AppService.h
//  Dipan
//
//  Created by qqn_pipi on 11-7-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppService : NSObject {
    
    dispatch_queue_t  workingQueue;

    
    NSString*         newVersion;
    NSString*         newAppURL;
    
    UIAlertView       *alertView;
}

@property (nonatomic, retain) NSString*         newVersion;
@property (nonatomic, retain) NSString*         newAppURL;
@property (nonatomic, retain) UIAlertView       *alertView;


- (void)startAppUpdate;

@end

extern AppService* GlobalGetAppService();