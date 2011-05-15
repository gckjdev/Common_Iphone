//
//  SelectCountryController.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-2.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@protocol SelectCountryControllerDelegate <NSObject>

- (void)didSelectCountry:(NSString*)countryLocalizedName countryTelPrefix:(NSString*)countryTelPrefix countryCode:(NSString*)countryCode;

@end

@interface SelectCountryController : PPTableViewController {
	
	NSString*	selectedCountryLocalizedName;
	id<SelectCountryControllerDelegate> delegate;
}

@property (nonatomic, retain) NSString*	selectedCountryLocalizedName;
@property (nonatomic, assign) id<SelectCountryControllerDelegate> delegate;

@end
