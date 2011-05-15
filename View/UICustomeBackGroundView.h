//
//  CustomCellBackgroundView.h
//  TableTest
//
//  Created by Stephan on 22.02.09.
//  Copyright 2009 Coriolis Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum  {
	CustomCellBackgroundViewPositionTop, 
	CustomCellBackgroundViewPositionMiddle, 
	CustomCellBackgroundViewPositionBottom,
	CustomCellBackgroundViewPositionSingle
} CustomCellBackgroundViewPosition;

@interface CustomCellBackgroundView : UIView {
	UIColor *borderColor;
	UIColor *fillColor;
	CustomCellBackgroundViewPosition position;
}

@property(nonatomic, retain) UIColor *borderColor, *fillColor;
@property(nonatomic) CustomCellBackgroundViewPosition position;
@end
