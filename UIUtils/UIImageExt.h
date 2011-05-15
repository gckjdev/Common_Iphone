//
//  UIImageExt.h
//  three20test
//
//  Created by qqn_pipi on 10-3-25.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (UIImageExt)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;
- (NSData*)getData;
@end
