//
//  SmsService.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-13.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "SmsService.h"
#import "SendSms.h"
#import "RemoteServiceManager.h"

@implementation SmsService

+ (SendSmsOutput*)sendSimpleSms:(NSString*)from to:(NSString*)to text:(NSString*)text appId:(NSString*)appId
{
	int result = kResultSuccess;
	SendSmsInput* input = [[SendSmsInput alloc] init];
	SendSmsOutput* output = [[[SendSmsOutput alloc] init] autorelease];
	
	// initlize all input data
	input.userId = from;
	input.receiverUserId = to;
	input.text = text;
	input.isSecure = NO;
	input.isSendLocation = NO;
	input.appId = appId;
	
	if ([[SendSmsRequest requestWithURL:kServerURL] sendRequest:input output:output])
		result = output.resultCode;
	else
		output.resultCode = kErrorNetworkProblem;
	
	[input release];	
	return output;
}

@end
