//
//  PPSegmentControl.h
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPSegmentControl;
@class PPViewController;

typedef void (^PPSegmentControlActionBlock)(PPSegmentControl* segControl, UIViewController* viewController);



@interface PPSegmentControl : UIView {
    
    NSMutableArray *buttonItems;
    UIImageView *selectedImageView;
    UIImageView *segmentBgImageView;    
    UIFont *selectedSegmentFont;
    UIColor *selectedSegmentColor;
    UIFont *unSelectedSegmentFont;
    UIColor *unSelectedSegmentColor;
    NSInteger selectedIndex;
    
}

@property (nonatomic, assign) PPSegmentControlActionBlock clickActionBlock;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) int buttonWidth;
@property (nonatomic, assign) int buttonHeight;
@property (nonatomic, retain) NSMutableArray *buttonItems;
@property (nonatomic, retain) UIImageView *selectedImageView;
@property (nonatomic, retain) UIImageView *segmentBgImageView;
@property (nonatomic, retain) UIColor *selectedSegmentColor;
@property (nonatomic, retain) UIFont *selectedSegmentFont;
@property (nonatomic, retain) UIColor *unSelectedSegmentColor;
@property (nonatomic, retain) UIFont *unSelectedSegmentFont;
@property (nonatomic, retain) UIViewController *viewController;

- (id)initWithItems:(NSArray*)titleArray 
 defaultSelectIndex:(int)defaultSelectIndex 
            bgImage:(UIImage *)bgImage 
      selectedImage:(UIImage *)selectedImage;

- (NSString*)titleForSegmentAtIndex:(NSInteger )index;
- (void)setBackgroundImage:(NSString*)imageName;
- (void)setSelectedSegmentFrame:(CGRect)frame image:(UIImage *)image;
- (void)setSelectedSegmentIndex:(NSInteger)index;
- (NSInteger)selectedSegmentIndex;
- (UIButton *)newAButtonWithTitle:(NSString *)title offset:(CGFloat)offset;
- (void)setSegmentFrame:(CGRect)frame;
- (void)setUnselectedTextFont:(UIFont *)font color:(UIColor *)color;
- (void)setSelectedTextFont:(UIFont *)font color:(UIColor *)color;
- (void)clickButton:(id)sender;
- (void)setXOffset:(NSInteger)x YOffset:(NSInteger)y;
@end

