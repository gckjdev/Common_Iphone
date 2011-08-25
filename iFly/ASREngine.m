//
//  ASREngine.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ASREngine.h"


#define APPID @"4e489885" // appid for phonechan -  iphone，请勿修改！
#define ENGINE_URL @"http://dev.voicecloud.cn/index.htm"
#define H_CONTROL_ORIGIN CGPointMake(20, 70)

@implementation ASREngine

- (BOOL)initEngine
{
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
	// 识别控件
	iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:H_CONTROL_ORIGIN 
                                                           theInitParam:initParam];
    
//	[self.view addSubview:_iFlyRecognizeControl];
	[iFlyRecognizeControl setEngine:@"sms" theEngineParam:nil theGrammarID:nil];
	[iFlyRecognizeControl setSampleRate:16000];
//	iFlyRecognizeControl.delegate = self;
    
	[initParam release];
//	_recoginzeSetupController = [[UIRecognizeSetupController alloc] initWithRecognize:_iFlyRecognizeControl];
}

@end
