//
//  SearchProductController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@interface SearchProductController : UIViewController<UISearchBarDelegate> {
    UIButton *latestSearchButton1;
	UIButton *latestSearchButton2;
	UIButton *latestSearchButton3;
	
}

@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton1;
@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton2;
@property (nonatomic, retain) IBOutlet UIButton *latestSearchButton3;
@end