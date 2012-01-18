//
//  GuideController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "AdViewUtils.h"
#import "GADBannerView.h"
#import "CategoryService.h"


@interface GuideController : PPViewController <UISearchBarDelegate, UIAlertViewDelegate, CategoryServiceDelegate> {

    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *searchButton;
    IBOutlet UISearchBar *keywordSearchBar;
    IBOutlet UIImageView *searchTextFieldBackground;
    IBOutlet UIImageView *searchBackgroundView;

    GADBannerView *bannerView_;    
    
    UIScrollView *scrollView;
    NSArray *categoryArray;
    NSArray *siteNameArray;
    NSArray *siteIdArray;
}

@property (retain, nonatomic) IBOutlet UIImageView *searchTextFieldBackgroundView;
@property (retain, nonatomic) IBOutlet UIButton *searchButton;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIImageView *searchBackgroundView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSArray *categoryArray;
@property (nonatomic, retain) NSArray *siteNameArray;
@property (nonatomic, retain) NSArray *siteIdArray;

- (IBAction) clickSearchButton:(id)sender;
@end
