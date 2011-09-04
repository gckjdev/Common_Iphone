//
//  ProductWriteCommentController.h
//  groupbuy
//
//  Created by penglzh on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "ProductService.h"
#import "groupbuyAppDelegate.h"


@interface ProductWriteCommentController : PPViewController <ProductServiceDelegate> {
    NSString *productId;
    UITextField *nickNameTextField;
    UITextView *contentTextView;
}

@property (nonatomic, retain) NSString *productId;
@property (nonatomic, retain) IBOutlet UITextField *nickNameTextField;
@property (nonatomic, retain) IBOutlet UITextView *contentTextView;

@end
