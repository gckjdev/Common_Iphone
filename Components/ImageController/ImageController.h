//
//  ImageController.h
//  Dipan
//
//  Created by qqn_pipi on 11-7-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "HJManagedImageV.h"


#define IMAGEVIEW_TAG 1000
#define IMAGEVIEW_MAX_SCALE 3.0
#define IMAGEVIEW_MIN_SCALE 1.0

@interface ImageController : PPViewController <HJManagedImageVDelegate,UIGestureRecognizerDelegate>{
    IBOutlet HJManagedImageV *imageView;
    NSString *imageURL;
    Boolean hasGetSize;
    IBOutlet UIActivityIndicatorView *loadImageActivity;
    CGSize size;
    CGFloat scale;
    CGPoint beginLocation;
}

+ (ImageController*)showImageController:(UIViewController*)superController
                               imageURL:(NSString*)imageURL;
-(void) pinchImage:(UIView *)view;
-(void) moveImage:(UIView *)view;
@property(retain,nonatomic)IBOutlet HJManagedImageV *imageView;
@property(retain,nonatomic)NSString *imageURL;
@property(retain,nonatomic) IBOutlet UIActivityIndicatorView *loadImageActivity;
@end
