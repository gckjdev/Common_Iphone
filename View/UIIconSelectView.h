//
//  UIIconSelectView.h
//  three20test
//
//  Created by qqn_pipi on 10-2-22.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kColumnNumberForIconList	4
//#define kMarginForIconList			15
#define kMarginWidthForIcon			16
#define kMarginHeightForIcon		11

#define kLeftForIconList			3
#define kTopForIconList				5

@protocol UIIconSelectViewDelegate;

@interface UIIconSelectView : UIView {

	NSArray*	iconArray;
	NSArray*	iconNameArray;
	
	NSString*	selectedImageName;
	
	id<UIIconSelectViewDelegate>	delegate;
}

@property (nonatomic, retain) NSArray*	iconArray;
@property (nonatomic, retain) NSArray*	iconNameArray;
@property (nonatomic, retain) NSString*	selectedImageName;
@property (nonatomic, retain) id<UIIconSelectViewDelegate>	delegate;

- (void)setIconList:(NSArray *)iconNameArray;
- (void)resetSelectedImage;

@end

@protocol UIIconSelectViewDelegate <NSObject>

@optional

- (void)iconSelectView:(UIIconSelectView*)view didSelectImage:(UIImage*)image imageName:(NSString*)imageName;

@end
