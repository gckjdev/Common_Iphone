//
//  UINavigationItemExt.h
//  Redial
//
//  Created by Peng Lingzhe on 8/11/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UINavigationItem (UINavigationItemExt)

- (void)setTitleViewWithLabel:(UILabel*)label;
- (void)setRichTextTitleView:(NSString*)title textColor:(UIColor*)color font:(UIFont*)font;
- (void)setTitleViewText:(NSString*)title;

@end
