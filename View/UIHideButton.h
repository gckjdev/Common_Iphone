//
//  UIHideButton.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-8.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIViewController (UIResignKeyboard)


- (UIButton *)createButton:(UIView *)v;

- (void)resignKeyboard:(id)sender;

+ (BOOL)resignKeyboardByView:(UIView *)aView;




@end
