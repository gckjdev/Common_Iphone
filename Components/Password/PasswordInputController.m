//
//  PasswordInputController.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-3-28.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "PasswordInputController.h"
#import "UITextTableViewCell.h"
#import "PPApplication.h"

#define kRowPasswordOne		0
#define kRowPasswordTwo		1
#define kTotalRow			2

#define kFontSize			15

@implementation PasswordInputController

@synthesize oldPasswordTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize canReturn;
@synthesize button1;
@synthesize button2;
@synthesize password;
@synthesize oldPassword;
@synthesize delegate;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id)initWithPassword:(NSString*)oldPasswordValue delegate:(id<PasswordInputControllerDelegate>)delegateValue
{
    self = [super init];
    if (self){
        self.oldPassword = oldPasswordValue;
        self.delegate = delegateValue;
    }
    
    return self;
}

- (void)initRow
{
    int row = 0;
    
    rowOldPassword = row ++;
    rowNewPassword = row ++;
    rowNewPasswordConfirm = row ++;
    totalRow = row;   
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [self initRow];
	
	[self.button1 setTitle:NSLS(@"确认") forState:UIControlStateNormal];
	
	if (canReturn){
		[self.button2 setTitle:NSLS(@"取消") forState:UIControlStateNormal];
		[self.button2 addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventTouchUpInside];
	}
	else{
		[self.button2 setTitle:NSLS(@"Help") forState:UIControlStateNormal];
		[self.button2 addTarget:self action:@selector(clickHelp:) forControlEvents:UIControlEventTouchUpInside];
	}
				
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidAppear:(BOOL)animated
{
//	[self.oldPasswordTextField becomeFirstResponder];
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [oldPasswordTextField release];
    [oldPassword release];
	[passwordTextField release];
	[confirmPasswordTextField release];
	[button1 release];
	[button2 release];
	[password release];
    [super dealloc];
}

#pragma mark Table View Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = @"";		
	return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return totalRow;
}

- (void)textDidEnd:(id)sender
{
	if (sender == passwordTextField){
		[confirmPasswordTextField becomeFirstResponder];
	}
    else if (sender == oldPasswordTextField){
        [passwordTextField becomeFirstResponder];
    }
    else if (sender == confirmPasswordTextField){
        [self clickOK:sender];
    }
}

- (UITextTableViewCell*)createPasswordCell:(NSString*)CellIdentifier
{
    UITextTableViewCell* cell = (UITextTableViewCell*)[dataTableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:CellIdentifier] autorelease];				

        cell.selectionStyle = UITableViewCellSelectionStyleNone;		
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        cell.textField.font = [UIFont systemFontOfSize:kFontSize];    
        
        [cell.textField addTarget:self 
                           action:@selector(textDidEnd:) 
                 forControlEvents:UIControlEventEditingDidEndOnExit];
        
        cell.textField.textColor = [UIColor colorWithRed:130/255.0 
                                                   green:111/255.0 
                                                    blue:95/255.0 
                                                   alpha:1.0];
        
        cell.textField.secureTextEntry = YES;
    }    

    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	int row = indexPath.row;	
    if (row == rowOldPassword){
        UITextTableViewCell* cell = [self createPasswordCell:@"PasswordCell0"];
        cell.textField.placeholder = NSLS(@"请输入当前密码");
        if (oldPasswordTextField == nil){
            self.oldPasswordTextField = cell.textField;        
//            [oldPasswordTextField becomeFirstResponder];
        }
        return cell;
    }
	else if (row == rowNewPassword){
        UITextTableViewCell* cell = [self createPasswordCell:@"PasswordCell1"];
        cell.textField.placeholder = NSLS(@"请输入新密码");
        self.passwordTextField = cell.textField;								
		return cell;
	}
	else if (indexPath.row == rowNewPasswordConfirm) {
        UITextTableViewCell* cell = [self createPasswordCell:@"PasswordCell2"];            
        cell.textField.placeholder = NSLS(@"请再次输入新密码");
        self.confirmPasswordTextField = cell.textField;		
		return cell;
	}
	
//		[self setCellBackground:cell row:row count:kTotalRow];

	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row > [dataList count] - 1)
		return;
	
	// do select row action
	// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)clickHelp:(id)sender
{
	[self popupMessage:NSLS(@"kPasswordHelp") title:GlobalGetAppName()];
}

- (void)clickOK:(id)sender
{
    if ([oldPasswordTextField.text length] == 0){
		[self popupUnhappyMessage:NSLS(@"密码不能为空吧") title:GlobalGetAppName()];
		[oldPasswordTextField becomeFirstResponder];
		return;        
    }
    
    if ([oldPasswordTextField.text isEqualToString:oldPassword] == 0){
		[self popupUnhappyMessage:NSLS(@"密码和原有密码不一致，请仔细检查一下吧") title:GlobalGetAppName()];
		[oldPasswordTextField becomeFirstResponder];
		return;        
    }    
    
	if (passwordTextField.text == nil || [passwordTextField.text length] == 0){
		[self popupUnhappyMessage:NSLS(@"密码不能为空吧") title:GlobalGetAppName()];
		[passwordTextField becomeFirstResponder];
		return;
	}

	if (confirmPasswordTextField.text == nil || [confirmPasswordTextField.text length] == 0){
		[self popupUnhappyMessage:NSLS(@"密码不能为空吧") title:GlobalGetAppName()];
		[confirmPasswordTextField becomeFirstResponder];
		return;
	}
		
	if ([passwordTextField.text isEqualToString:confirmPasswordTextField.text] == NO){
		[self popupUnhappyMessage:NSLS(@"输入的密码不一致，请重新输入吧") title:GlobalGetAppName()];
		[passwordTextField becomeFirstResponder];		
		return;
	}
	
	int MIN_PASSWORD_LEN = 6;
	if ([passwordTextField.text length] < MIN_PASSWORD_LEN){
		[self popupUnhappyMessage:NSLS(@"密码长度至少要6位吧，请补足下可以吗？") title:GlobalGetAppName()];
		[passwordTextField becomeFirstResponder];		
		return;
	}
	    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (delegate && [delegate respondsToSelector:@selector(didPasswordChange:)]){
        [delegate didPasswordChange:[passwordTextField text]];
    }
}

- (void)clickReturn:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
