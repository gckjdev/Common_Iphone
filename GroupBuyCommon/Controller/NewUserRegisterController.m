//
//  NewUserRegisterController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-9-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewUserRegisterController.h"
#import "UITextTableViewCell.h"
#import "GroupBuyUserService.h"
#import "GroupBuyUserService.h"
#import "StringUtil.h"
#import "MyInfoController.h"
#import "GroupBuyControllerExt.h"
#import "UIImageUtil.h"

enum {
    ROW_EMAIL,
    ROW_PASSWORD,
    ROW_CONFIRM_PASSWORD,
    ROW_NUMBER    
};

@implementation NewUserRegisterController

@synthesize submitButton;
@synthesize email;
@synthesize password;
@synthesize confirmPassword;

+ (NewUserRegisterController*)showController:(NSString*)defaultEmail password:(NSString*)defaultPassword superController:(UIViewController*)superController
{
    NewUserRegisterController* vc = [[[NewUserRegisterController alloc] init] autorelease];
    vc.email = defaultEmail;
    vc.password = defaultPassword;
    [vc setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [superController.navigationController pushViewController:vc animated:YES];
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [email release];
    [password release];
    [confirmPassword release];
    [submitButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.navigationItem.title = @"注册";
    [self setGroupBuyNavigationTitle:self.navigationItem.title];
    [self setGroupBuyNavigationBackButton];
    
    [self.submitButton setBackgroundImage:[UIImage strectchableImageName:@"tu_129.png"] forState:UIControlStateNormal];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self performSelector:@selector(setKeyboardFocus) withObject:nil afterDelay:1.0];
}

- (void)setKeyboardFocus
{
    [emailTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setSubmitButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table View Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];		
	return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ROW_NUMBER;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
		
		if (cellTextLabelColor != nil)
			cell.textLabel.textColor = cellTextLabelColor;
		else
			cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
		
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			    
        
        UITextField* textField = ((UITextTableViewCell*)cell).textField;    
        ((UITextTableViewCell*)cell).delegate = self;
        
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;  
        textField.textColor = [self getDefaultTextColor];
        switch (indexPath.row) {
            case ROW_EMAIL:
            {
                textField.placeholder = @"请输入电子邮件地址";
                textField.text = email;
                textField.secureTextEntry = NO;      
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                emailTextField = textField;
                [textField becomeFirstResponder];
            }
                break;
                
            case ROW_PASSWORD:
            {
                textField.placeholder = @"请输入密码";
                textField.text = password;
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeDefault;
                passwordTextField = textField;
            }
                break;
                
            case ROW_CONFIRM_PASSWORD:
            {
                textField.placeholder = @"请重新输入密码";
                textField.secureTextEntry = YES;
                textField.keyboardType = UIKeyboardTypeDefault;
                confirmPasswordTextField = textField;
            }
                break;
                
            default:
                break;
        }
        
	}
    
    ((UITextTableViewCell*)cell).indexPath = indexPath;
    
    int count = [self tableView:theTableView numberOfRowsInSection:indexPath.section];
    [cell setCellBackgroundForRow:indexPath.row rowCount:count singleCellImage:SINGLE_CELL_IMAGE firstCellImage:FIRST_CELL_IMAGE  middleCellImage:MIDDLE_CELL_IMAGE lastCellImage:LAST_CELL_IMAGE cellWidth:300];
    
	return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)verifyField
{
    if ([emailTextField.text length] == 0){
        [UIUtils alert:@"电子邮件地址不能为空"];
        [emailTextField becomeFirstResponder];
        return NO;
    }
    
    if (NSStringIsValidEmail(emailTextField.text) == NO){
        [UIUtils alert:@"输入的电子邮件地址不合法，请重新输入"];
        [emailTextField becomeFirstResponder];
        return NO;        
    }
    
    if ([passwordTextField.text length] == 0){
        [UIUtils alert:@"密码不能为空"];
        return NO;
    }

    if ([confirmPasswordTextField.text isEqualToString:passwordTextField.text] == NO){
        [UIUtils alert:@"密码和确认密码输入不一致，请确认重新输入"];
        [passwordTextField becomeFirstResponder];
        return NO;
    }    
    
    return YES;
}

- (IBAction)clickRegister:(id)sender
{
    if ([self verifyField] == NO)
        return;
    
    UserService* userService = GlobalGetUserService();
    [userService registerUser:emailTextField.text password:passwordTextField.text viewController:self];         
}

- (void)textChange:(UITextField *)textField atIndex:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case ROW_EMAIL:
//            self.email = textField.text;
            break;
            
        case ROW_PASSWORD:
//            self.password = textField.text;
            break;
            
        case ROW_CONFIRM_PASSWORD:
//            self.confirmPassword = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)textEditBegin:(UITextField *)textField atIndex:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case ROW_EMAIL:
            break;
            
        case ROW_PASSWORD:
            break;
            
        case ROW_CONFIRM_PASSWORD:
            break;
            
        default:
            break;
    }       
   
}

- (void)textFieldDone:(UITextField *)textField atIndex:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case ROW_EMAIL:
            [passwordTextField becomeFirstResponder];
            break;
            
        case ROW_PASSWORD:
            [confirmPasswordTextField becomeFirstResponder];
            break;
            
        case ROW_CONFIRM_PASSWORD:
            [emailTextField becomeFirstResponder];
            break;
            
        default:
            break;
    } 
    
}

- (void)actionDone:(int)result
{
    NSLog(@"register finish, result = %d", result);
    if (result == 0){
        [MyInfoController show:self.navigationController];
    }
}

- (void)clickBack:(id)sender
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
