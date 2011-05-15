//
//  UINumberAccessoryView.h
//  three20test
//
//  Created by qqn_pipi on 10-5-29.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINumberAccessoryView : UIView {

	UIImageView	*numberBackground;	
	UILabel		*numberLabel;
	UIImageView *detailedImage;	
	
}

@property (nonatomic, retain) UIImageView	*numberBackground;	
@property (nonatomic, retain) UILabel		*numberLabel;
@property (nonatomic, retain) UIImageView	*detailedImage;	

- (void)setNumber:(int)number;

@end
