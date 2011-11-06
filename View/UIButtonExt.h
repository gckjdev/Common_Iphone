//
//  UIButtonExt.h
//  Test
//
//  Created by Peng Lingzhe on 5/21/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (UIButtonExt)

- (void)setBackgroundImage:(UIImage*)image;
- (void)setBackgroundImageByName:(NSString*)imageName;
- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;



@end
