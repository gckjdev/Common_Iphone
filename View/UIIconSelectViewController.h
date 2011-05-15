//
//  UIIconSelectViewController.h
//  three20test
//
//  Created by qqn_pipi on 10-2-22.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIIconSelectView.h"

#define kTitleSelectIcon		NSLocalizedString(@"Select Display Icon", @"Select Display Icon")
#define kInfoFromPhoto			NSLocalizedString(@"From Photos", @"From Photos")
#define kMsgFailAccessAlbum		NSLocalizedString(@"Fail to access photo album.", @"")

#define kIconWidth				57
#define kIconHeight				57

@interface UIIconSelectViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	// create and manage by the contoller itself
	UIIconSelectView				*iconView;		
	UIImageView						*backgroundImageView;

	// should be set by external caller
	id<UIIconSelectViewDelegate>	delegate;	
	NSString						*backgroundImage;		
	NSArray							*iconArray;
	
	UIActivityIndicatorView			*indicatorView;
	
	NSString						*tempDir;
	UINavigationController			*nav;
}

@property (nonatomic, retain) 	UIIconSelectView				*iconView;
@property (nonatomic, retain)	id<UIIconSelectViewDelegate>	delegate;
@property (nonatomic, retain)	UIImageView						*backgroundImageView;
@property (nonatomic, retain)	NSString						*backgroundImage;	
@property (nonatomic, retain)	NSArray							*iconArray;
@property (nonatomic, retain)	UIActivityIndicatorView			*indicatorView;
@property (nonatomic, retain)	NSString						*tempDir;
@property (nonatomic, retain)	UINavigationController			*nav;

//- (void)setIconList:(NSArray *)iconNameArray;
//- (void)resetSelectedImage;

@end
