//
//  UIBackgroundView.h
//  MyPhoneService
//
//  Created by qqn_pipi on 10-3-13.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIBackgroundView : UIImageView {
	
	UIImageView		*imageView;	
	
}

@property (nonatomic, retain) UIImageView	*imageView;

- (id)initWithImageName:(NSString *)string inView:(UIView *)inView;

@end
