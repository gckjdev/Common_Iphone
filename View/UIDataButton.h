//
//  UIDataButton.h
//  three20test
//
//  Created by qqn_pipi on 10-5-18.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDataButton : UIButton {

	NSObject*	data;
}

@property (nonatomic, retain) NSObject*	data;

@end
