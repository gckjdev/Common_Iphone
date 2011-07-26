//
//  MobClick.h
//  MobClick
//
//  Created by Aladdin on 3/25/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum{
	BATCH = 0,
	REALTIME
}ReportPolicy;

@protocol MobClickDelegate;
@interface MobClick : NSObject <UIAlertViewDelegate>{
@private
	id _internal;
}
#pragma mark basics
+ (void)setDelegate:(id<MobClickDelegate>)delegate;
+ (void)setDelegate:(id<MobClickDelegate>)delegate reportPolicy:(ReportPolicy)rp;
+ (void)appLaunched;
+ (void)appTerminated;
#pragma mark event logs
+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId label:(NSString *)label;

+ (void)event:(NSString *)eventId acc:(NSInteger)accumulation;
+ (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation;
#pragma mark feedback
+ (void)showFeedback:(UIViewController *)rootViewcontroller;
#pragma mark helper

+ (BOOL)isJailbroken;
+ (BOOL)isPirated;

@end

@protocol MobClickDelegate <NSObject>
@required
- (NSString *)appKey;
@optional
- (NSString *)channelId;
@end