//
//  UIViewController+DownloadViewControllerAddition.m
//  Download
//
//  Created by  on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+DownloadViewControllerAddition.h"
#import "DownloadResource.h"
#import "LocaleUtils.h"

@implementation UIViewController (DownloadViewControllerAddition)

- (void)setDownloadRightBarButton:(NSString*)buttonText selector:(SEL)selector
{
    float buttonHigh = 27.5;
    float nextButtonLen = 60;
    
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    nextButtonLen = [buttonText sizeWithFont:font].width + 10;
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(218, 0, nextButtonLen, buttonHigh)];
    [nextButton setBackgroundImage:ITEM_NEXT_ICON_IMAGE forState:UIControlStateNormal];
    

    [nextButton.titleLabel setFont:font];
    [nextButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [nextButton setTitle:buttonText forState:UIControlStateNormal];
    [nextButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];    
}

- (void)setBackButton
{
    float buttonHigh = 27.5;
    float backButtonLen = 60;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, backButtonLen, buttonHigh)];
    [backButton setBackgroundImage:ITEM_BACK_ICON_IMAGE forState:UIControlStateNormal];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [backButton.titleLabel setFont:font];
    [backButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backButton setTitle:NSLS(@"Back") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
}


@end
