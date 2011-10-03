//
//  PasswordInputController.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-28.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@protocol PasswordInputControllerDelegate <NSObject>

- (void)didPasswordChange:(NSString*)newPassword;

@end


@interface PasswordInputController : PPTableViewController {

	UITextField		*passwordTextField;
	UITextField		*confirmPasswordTextField;
    UITextField		*oldPasswordTextField;
	
	BOOL			canReturn;
	
	IBOutlet UIButton	*button1;
	IBOutlet UIButton	*button2;
	
	NSString			*password;
    NSString            *oldPassword;
    
    int rowOldPassword;
    int rowNewPassword;
    int rowNewPasswordConfirm;
    int totalRow;        
    
    id<PasswordInputControllerDelegate> delegate;
}

@property (nonatomic, retain) UITextField		*passwordTextField;
@property (nonatomic, retain) UITextField		*confirmPasswordTextField;
@property (nonatomic, retain) UITextField		*oldPasswordTextField;


@property (nonatomic, retain) NSString			*password;
@property (nonatomic, assign) BOOL				canReturn;
@property (nonatomic, retain) IBOutlet UIButton	*button1;
@property (nonatomic, retain) IBOutlet UIButton	*button2;
@property (nonatomic, assign) id<PasswordInputControllerDelegate> delegate;
@property (nonatomic, retain) NSString            *oldPassword;

- (id)initWithPassword:(NSString*)oldPasswordValue delegate:(id<PasswordInputControllerDelegate>)delegateValue;

- (void)clickHelp:(id)sender;
- (void)clickOK:(id)sender;
- (void)clickReturn:(id)sender;

@end
