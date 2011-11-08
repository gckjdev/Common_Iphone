//
//  PPSegmentControl.h
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPSegmentControl;

@protocol PPSegmentControlDelegate <NSObject>
-(void)didSegmentValueChange:(PPSegmentControl *)seg;
@end

@interface PPSegmentControl : UIView {
    
    NSMutableArray *_segments;
    UIImageView *_backgroudImageView;
    UIImageView *_selectedSegmentImageView;
    UIFont *_textFont;
    UIFont *_selectedSegmentTextFont;
    UIColor *_textColor;
    UIColor *_selectedSegmentTextColor;
    CGFloat segmentWidth;
    CGFloat segmentHeight;
    id<PPSegmentControlDelegate> delegate;
}

@property (nonatomic, assign) id<PPSegmentControlDelegate> delegate;
@property(nonatomic, readonly) NSUInteger numberOfSegments;
@property(nonatomic, assign) NSInteger selectedSegmentIndex;
@property(nonatomic, retain) UIImageView *backgroudImageView;
@property(nonatomic, retain) UIImageView *selectedSegmentImageView;

-(id) initWithItems:(NSArray *)titleArray defaultSelectIndex:(int)defaultSelectIndex 
              frame:(CGRect)frame;

//set imaget and font
- (void) setBackgroundImage:(UIImage *)backgroundImage;
- (void) setSelectedSegmentImage:(UIImage *)selectedSegmentImage;
- (void) setSelectedSegmentTextColor:(UIColor *)color;
- (void) setSelectedSegmentTextFont:(UIFont *)font;

- (void) setTextColor:(UIColor *)color;
- (void) setTextFont: (UIFont *)font;

- (void) setSegmentFrame:(CGRect)frame;

//set and get segment title;
- (NSString*) titleForSegmentAtIndex:(NSInteger )index;
- (NSString *) titleForSelectedSegment;
- (void) setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
- (void) setSelectedSegmentIndex:(NSInteger)index;
- (void) setContentOffset:(CGFloat)x y:(CGFloat)y;

@end


