//
//  PPSegmentControl.h
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPSegmentControl;

typedef void (^PPSegmentControlActionBlock)(PPSegmentControl* segControl);


@interface PPSegmentControl : UIView {
    
    NSMutableArray *buttonItems;
    UIImageView *selectedImageView;
    UIImageView *segmentBgImageView;    
}

@property (nonatomic, assign) PPSegmentControlActionBlock clickActionBlock;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) int buttonWidth;
@property (nonatomic, assign) int buttonHeight;
@property (nonatomic, retain) NSMutableArray *buttonItems;
@property (nonatomic, retain) UIImageView *selectedImageView;
@property (nonatomic, retain) UIImageView *segmentBgImageView;

- (id)initWithItems:(NSArray*)titleArray 
 defaultSelectIndex:(int)defaultSelectIndex 
        bgImageName:(NSString *)bgImageName 
  selectedImageName:(NSString *)selectedImageName;

- (NSString*)titleForSegmentAtIndex:(NSInteger )index;
- (void)setBackgroundImage:(NSString*)imageName;
- (void)setSelectedSegmentIndex:(NSInteger)index;
- (UIButton *)newAButtonWithTitle:(NSString *)title offset:(CGFloat)offset;
- (void)setSegmentFrame:(CGRect)frame;

- (void)clickButton:(id)sender;
@end

