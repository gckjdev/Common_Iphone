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

@synthesize textView;

- (BOOL)showControl:(UIView*)superView displayTextView:(UIView*)displayTextView
{
    if (iFlyRecognizeControl == nil){
        NSString *initParam = [[NSString alloc] initWithFormat:
                               @"server_url=%@,appid=%@",ENGINE_URL,APPID];
        
        // 识别控件
        iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:H_CONTROL_ORIGIN 
                                                               theInitParam:initParam];
        
        [initParam release];

        [iFlyRecognizeControl setEngine:@"sms" theEngineParam:nil theGrammarID:nil];
        [iFlyRecognizeControl setSampleRate:16000];
        iFlyRecognizeControl.delegate = self;
        
    }
    
    self.textView = displayTextView;
    [superView addSubview:iFlyRecognizeControl];
    [iFlyRecognizeControl start];

    return YES;
}

- (void)dealloc
{
    [textView release];
    [iFlyRecognizeControl release];
    [super dealloc];
}

#pragma mark 
#pragma mark 接口回调

//	识别结束回调
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControlVal theError:(SpeechError) error
{
	NSLog(@"<onRecognizeEnd> finish, Upflow:%d, Downflow:%d",[iFlyRecognizeControl getUpflow],[iFlyRecognizeControl getDownflow]);
    
}

- (void)onUpdateView:(NSString *)sentence
{
    sentence = [sentence stringByReplacingOccurrencesOfString:@"。" withString:@""];
    sentence = [sentence stringByReplacingOccurrencesOfString:@"？" withString:@""];
    
    if ([sentence length] <= 0)
        return;
    
    if ([textView respondsToSelector:@selector(text)] == NO ||
        [textView respondsToSelector:@selector(setText:)] == NO)
        return;
    
    NSString* text = [textView performSelector:@selector(text)];        
    if ([text length] > 0){
        NSString *str = [[NSString alloc] initWithFormat:@"%@ %@", text, sentence];
        [textView performSelector:@selector(setText:) withObject:str];
        [str release];
    }
    else{
        [textView performSelector:@selector(setText:) withObject:sentence];
    }
}

- (void)onRecognizeResult:(NSArray *)array
{
    if ([array count] <= 0){
        NSLog(@"<onRecognizeResult> no result found");
        return;
    }
    else{
        NSLog(@"<onRecognizeResult> result = %@", [array objectAtIndex:0]);
    }
    
	[self performSelectorOnMainThread:@selector(onUpdateView:) withObject:
	 [[array objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControlVal theResult:(NSArray *)resultArray
{
	[self onRecognizeResult:resultArray];	
}


@end
