//
//  PPSegmentControl.h
//  groupbuy
//
//  Created by qqn_pipi on 11-10-20.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPSegmentControl;

typedef void (^PPSegmentControlActionBlock)(id delegate, PPSegmentControl* segControl);


@interface PPSegmentControl : UIView {
    
    
    
}

@property (nonatomic, assign) PPSegmentControlActionBlock clickActionBlock;
@property (nonatomic, assign) int selectedSegmentIndex;

- (id)initWithItems:(NSArray*)titleArray defaultSelectIndex:(int)defaultSelectIndex;
- (void)setClickAction:(id)delegate actionBlock:(PPSegmentControlActionBlock)block;
- (NSString*)titleForSegmentAtIndex;

- (void)setBackgroundImage:(NSString*)imageName;
- (void)setSelectedBackgroundImage:(NSString*)imageName;
- (void)selectIndex:(int)index;

@end

