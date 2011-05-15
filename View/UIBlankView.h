//
//  UIBlankView.h
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-6.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBlankViewTag		98899

@protocol UIBlankViewDelegate <NSObject>

- (void)didClickBlankView;

@end


@interface UIBlankView : UIView {

	UIView	*currentKeyboardResponder;
	UIView	*fatherView;
	
	CGRect	initFrame;
	
	BOOL	isRegister;
	
	id<UIBlankViewDelegate> delegate;
}

@property (nonatomic, retain) UIView	*currentKeyboardResponder;
@property (nonatomic, retain) UIView	*fatherView;
@property (nonatomic) CGRect			initFrame;
@property (nonatomic, assign) id<UIBlankViewDelegate> delegate;

- (void)registerKeyboardNotification:(UIView *)theResponder fatherView:(UIView *)theFatherView frame:(CGRect)theFrame;
- (void)deregsiterKeyboardNotification;

- (void)keyboardDidShow:(NSNotification *)notification;

@end
