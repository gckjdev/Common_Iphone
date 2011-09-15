//
//  NewUserRegisterController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-9-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface NewUserRegisterController : PPTableViewController {

    NSString    *email;
    NSString    *password;
    NSString    *confirmPassword;
    
    UITextField *emailTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
}

@property (nonatomic, retain) NSString    *email;
@property (nonatomic, retain) NSString    *password;
@property (nonatomic, retain) NSString    *confirmPassword;

+ (NewUserRegisterController*)showController:(NSString*)defaultEmail password:(NSString*)defaultPassword superController:(UIViewController*)superController;

- (IBAction)clickRegister:(id)sender;

@end
