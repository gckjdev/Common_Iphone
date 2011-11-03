//
//  UIImageUtil.h
//  three20test
//
//  Created by qqn_pipi on 10-3-23.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (UIImageUtil)

- (BOOL)saveImageToFile:(NSString*)fileName;
+ (CGRect)shrinkFromOrigRect:(CGRect)origRect imageSize:(CGSize)imageSize;
+ (NSData *)compressImage:(UIImage *)image;


+ (UIImage*)strectchableImageName:(NSString*)name;
+ (UIImage*)strectchableImageName:(NSString*)name leftCapWidth:(int)leftCapWidth;
- (UIImage*)defaultStretchableImage;

@end
