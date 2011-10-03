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

@synthesize passwordTextField;
@synthesize confirmPasswordTextField;
@synthesize canReturn;
@synthesize button1;
@synthesize button2;
@synthesize password;


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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[self.button1 setTitle:NSLS(@"kPasswordOK") forState:UIControlStateNormal];
	
	if (canReturn){
		[self.button2 setTitle:NSLS(@"Cancel") forState:UIControlStateNormal];
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
	[self.passwordTextField becomeFirstResponder];
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
	
	//	switch (section) {
	//		case <#constant#>:
	//			<#statements#>
	//			break;
	//		default:
	//			break;
	//	}
	
	return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return kTotalRow;			// default implementation
}


- (void)textDidEnd:(id)sender
{
	if (sender == passwordTextField){
		[confirmPasswordTextField becomeFirstResponder];
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	int row = indexPath.row;	
	if (row == kRowPasswordOne){
		static  NSString *CellIdentifier = @"PasswordCell1";
		UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {		
			cell = [[[UITextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
			cell.selectionStyle = UITableViewCellSelectionStyleNone;		
			((UITextTableViewCell*)cell).textField.keyboardType = UIKeyboardTypeDefault;
			((UITextTableViewCell*)cell).textField.placeholder = NSLS(@"请输入旧密码");
			((UITextTableViewCell*)cell).textField.font = [UIFont systemFontOfSize:kFontSize];
			
			self.passwordTextField = ((UITextTableViewCell*)cell).textField;
//			[self.passwordTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
			[self.passwordTextField addTarget:self action:@selector(textDidEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
			
			((UITextTableViewCell*)cell).textField.textColor = [UIColor colorWithRed:130/255.0 green:111/255.0 blue:95/255.0 alpha:1.0];
			((UITextTableViewCell*)cell).textField.secureTextEntry = YES;
								
			if (password != nil){
				((UITextTableViewCell*)cell).textField.text = password;
			}
		}		
		
//		[self setCellBackground:cell row:row count:kTotalRow];
		
		if ([self.confirmPasswordTextField isFirstResponder] == NO){
			[self.passwordTextField becomeFirstResponder];
		}
		
		
		return cell;
	}
	else {
		static  NSString *CellIdentifier = @"PasswordCell2";
		UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {		
			cell = [[[UITextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
			cell.selectionStyle = UITableViewCellSelectionStyleNone;		
			((UITextTableViewCell*)cell).textField.keyboardType = UIKeyboardTypeDefault;
			((UITextTableViewCell*)cell).textField.placeholder = NSLS(@"kConfirmPassword");
			((UITextTableViewCell*)cell).textField.font = [UIFont systemFontOfSize:kFontSize];
			
			self.confirmPasswordTextField = ((UITextTableViewCell*)cell).textField;
//			[self.confirmPasswordTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
			
			((UITextTableViewCell*)cell).textField.textColor = [UIColor colorWithRed:130/255.0 green:111/255.0 blue:95/255.0 alpha:1.0];
			((UITextTableViewCell*)cell).textField.secureTextEntry = YES;
			
			if (password != nil){
				((UITextTableViewCell*)cell).textField.text = password;
			}
		}		
		
//		[self setCellBackground:cell row:row count:kTotalRow];
		
		
		return cell;
	}
	
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < 0 || indexPath.row > [dataList count] - 1)
		return;
	
	// do select row action
	// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row < 0 || indexPath.row > [dataList count] - 1)
			return;
		
		// take delete action below, update data list
		// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];		
		
		// update table view
		
	}
	
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	// create the parent view that will hold header Label
//	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
//	
//	// create the button object
//	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//	headerLabel.backgroundColor = [UIColor clearColor];
//	headerLabel.opaque = NO;
//	headerLabel.textColor = [UIColor blackColor];
//	headerLabel.highlightedTextColor = [UIColor whiteColor];
//	headerLabel.font = [UIFont boldSystemFontOfSize:20];
//	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
//	
//	// If you want to align the header text as centered
//	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
//	
//	headerLabel.text = <Put here whatever you want to display> // i.e. array element
//	[customView addSubview:headerLabel];
//	
//	return customView;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return 44.0;
//}

- (void)clickHelp:(id)sender
{
	[self popupMessage:NSLS(@"kPasswordHelp") title:GlobalGetAppName()];
}

- (void)clickOK:(id)sender
{
	if (passwordTextField.text == nil || [passwordTextField.text length] == 0){
		[self popupUnhappyMessage:NSLS(@"kPasswordEmpty") title:GlobalGetAppName()];
		[passwordTextField becomeFirstResponder];
		return;
	}

	if (confirmPasswordTextField.text == nil || [confirmPasswordTextField.text length] == 0){
		[self popupUnhappyMessage:NSLS(@"kPasswordEmpty") title:GlobalGetAppName()];
		[confirmPasswordTextField becomeFirstResponder];
		return;
	}
		
	if ([passwordTextField.text isEqualToString:confirmPasswordTextField.text] == NO){
		[self popupUnhappyMessage:NSLS(@"kPasswordNotEqual") title:GlobalGetAppName()];
		[passwordTextField becomeFirstResponder];		
		return;
	}
	
	int MIN_PASSWORD_LEN = 6;
	if ([passwordTextField.text length] < MIN_PASSWORD_LEN){
		[self popupUnhappyMessage:NSLS(@"kPasswordLenTooShort") title:GlobalGetAppName()];
		[passwordTextField becomeFirstResponder];		
		return;
	}
	
//	[ConfigManager setPassword:passwordTextField.text];
	
	if (canReturn == NO){
//		FreeSMSAppDelegate* appDelegate = (FreeSMSAppDelegate*)[[UIApplication sharedApplication] delegate];
//		[appDelegate hideSetPasswordView];
	}
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}

}

- (void)clickReturn:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
