//
//  TaobaoSearchResultController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-9-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ProductService.h"

@interface TaobaoSearchResultController : PPTableViewController<ProductServiceDelegate> {
    
    NSString* searchKeyword;
    double      price;
    double      value;}

@property (nonatomic, retain) NSString* searchKeyword;
@property (nonatomic, assign) double      price;
@property (nonatomic, assign) double      value;

- (id)initWithSearchKeyword:(NSString*)keyword;
+ (TaobaoSearchResultController*)showController:(UIViewController*)superController 
                                        keyword:(NSString*)keyword
                                          price:(double)price
                                          value:(double)value;


@end
