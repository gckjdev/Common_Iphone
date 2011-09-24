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

@interface TaobaoSearchController : PPViewController<ProductServiceDelegate, UISearchBarDelegate> {

    NSString    *text;
    double      price;
    double      value;
    
    UIView *keywordBackgroundView;
    UISearchBar *searchBar;
}

@property (nonatomic, retain) NSString    *text;
@property (nonatomic, assign) double      price;
@property (nonatomic, assign) double      value;

@property (nonatomic, retain) IBOutlet UIView *keywordBackgroundView;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
+ (TaobaoSearchController*)showController:(UIViewController*)superController 
                                     text:(NSString*)text 
                                    price:(double)price
                                    value:(double)value;

@end
