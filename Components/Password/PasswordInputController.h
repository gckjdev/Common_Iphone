//
//  PasswordInputController.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-28.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface PasswordInputController : PPTableViewController {

	UITextField		*passwordTextField;
	UITextField		*confirmPasswordTextField;
	
	BOOL			canReturn;
	
	IBOutlet UIButton	*button1;
	IBOutlet UIButton	*button2;
	
	NSString			*password;
}

@property (nonatomic, retain) UITextField		*passwordTextField;
@property (nonatomic, retain) UITextField		*confirmPasswordTextField;
@property (nonatomic, retain) NSString			*password;
@property (nonatomic, assign) BOOL				canReturn;
@property (nonatomic, retain) IBOutlet UIButton	*button1;
@property (nonatomic, retain) IBOutlet UIButton	*button2;

- (void)clickHelp:(id)sender;
- (void)clickOK:(id)sender;
- (void)clickReturn:(id)sender;

@end
