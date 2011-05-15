//
//  ViewControllerUtils.h
//  three20test
//
//  Created by qqn_pipi on 10-4-6.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewController (UIViewControllerUtils)

- (void)setLeftBackButton:(SEL)selector;
- (void)setLeftCancelButton:(SEL)selector;
- (void)clickBack:(id)sender;
- (void)clickRemoveFromSuperView:(id)sender;
- (void)addAnimation:(int)tag;

@end
