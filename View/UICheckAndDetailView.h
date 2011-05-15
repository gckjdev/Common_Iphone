//
//  UICheckAndDetailView.h
//  three20test
//
//  Created by qqn_pipi on 10-5-29.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UICheckAndDetailViewDelegate;

@interface UICheckAndDetailView : UIView {

	// internal objects
	UIButton* checkMarkButton; 
	UIButton* disclosureButton;
	
	// external objects
	id<UICheckAndDetailViewDelegate>	delegate;
	NSIndexPath							*indexPath;
		
}

@property (nonatomic, retain) NSIndexPath						*indexPath;
@property (nonatomic, assign) id<UICheckAndDetailViewDelegate>	delegate;
@property (nonatomic, assign) UIButton* checkMarkButton; 
@property (nonatomic, assign) UIButton* disclosureButton;

- (void)showDisclosureButton;
- (void)hideDisclosureButton;
- (void)showCheckMark;
- (void)hideCheckMark;
- (BOOL)isCheck;

@end

@protocol UICheckAndDetailViewDelegate <NSObject>

- (void)clickDisclosureButtonAtIndexPath:(NSIndexPath*)indexPath;

@end