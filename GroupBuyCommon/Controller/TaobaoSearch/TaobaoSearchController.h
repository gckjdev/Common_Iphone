//
//  TaobaoSearchController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "ProductService.h"

@interface TaobaoSearchController : PPViewController<ProductServiceDelegate, UISearchBarDelegate, UITextFieldDelegate> {

    NSString    *text;
    double      price;
    double      value;
    
    UIScrollView *keywordBackgroundView;
//    UISearchBar *searchBar;
}

@property (nonatomic, retain) NSString    *text;
@property (nonatomic, assign) double      price;
@property (nonatomic, assign) double      value;

@property (nonatomic, retain) IBOutlet UIScrollView *keywordBackgroundView;
@property (retain, nonatomic) IBOutlet UIImageView *searchTextFieldBackgroundView;
@property (retain, nonatomic) IBOutlet UIButton *searchButton;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet UIImageView *searchBackgroundView;

//@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
+ (TaobaoSearchController*)showController:(UIViewController*)superController 
                                     text:(NSString*)text 
                                    price:(double)price
                                    value:(double)value;
- (IBAction) clickSearchButton:(id)sender;
@end
