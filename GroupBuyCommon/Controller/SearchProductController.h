//
//  SearchProductController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

#import "ASREngine.h"
//#import "iFlyISR/IFlyRecognizeControl.h"

//#define APPID @"4e489885" // appid for phonechan -  iphone，请勿修改！
//#define ENGINE_URL @"http://dev.voicecloud.cn/index.htm"
//#define H_CONTROL_ORIGIN CGPointMake(20, 70)

@interface SearchProductController : PPViewController <UISearchBarDelegate> {
    UIButton *latestSearchButton1;
	UIButton *latestSearchButton2;
	UIButton *latestSearchButton3;
    IBOutlet UISearchBar *keywordSearchBar;

    ASREngine   *asrEngine;
}

@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton1;
@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton2;
@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton3;


- (IBAction) doSearch:(id)sender;
- (IBAction) speechSearch:(id)sender;

@end
