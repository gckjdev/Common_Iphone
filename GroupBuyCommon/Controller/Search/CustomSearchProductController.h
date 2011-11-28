//
//  SearchProductController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "GADBannerView.h"

//#import "ASREngine.h"

@interface CustomSearchProductController : PPViewController <UISearchBarDelegate, UIAlertViewDelegate> {
    UIButton *latestSearchButton1;
	UIButton *latestSearchButton2;
	UIButton *latestSearchButton3;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *searchButton;
    IBOutlet UISearchBar *keywordSearchBar;
    IBOutlet UIImageView *searchTextFieldBackground;
    IBOutlet UIImageView *searchBackgroundView;

    
    GADBannerView *bannerView_;     
//    ASREngine   *asrEngine;
}
@property (retain, nonatomic) IBOutlet UIButton *testButton;
@property (retain, nonatomic) IBOutlet UIImageView *searchTextFieldBackgroundView;
@property (retain, nonatomic) IBOutlet UIButton *searchButton;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIImageView *searchBackgroundView;

@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton1;
@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton2;
@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton3;


- (IBAction) doSearch:(id)sender;
- (IBAction) speechSearch:(id)sender;
- (IBAction) clickSearchButton:(id)sender;
@end
