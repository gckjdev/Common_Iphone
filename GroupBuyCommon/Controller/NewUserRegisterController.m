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

enum {
    ROW_EMAIL,
    ROW_PASSWORD,
    ROW_CONFIRM_PASSWORD,
    ROW_NUMBER    
};

@implementation NewUserRegisterController

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
    [self setBackgroundImageName:@"background.png"];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
        
        
	}
    
    UITextField* textField = ((UITextTableViewCell*)cell).textField;
    
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    switch (indexPath.row) {
        case ROW_EMAIL:
            textField.placeholder = @"请输入电子邮件地址";
            textField.text = email;
            textField.secureTextEntry = NO;
            break;
            
        case ROW_PASSWORD:
            textField.placeholder = @"请输入密码";
            textField.text = password;
            textField.secureTextEntry = YES;
            break;

        case ROW_CONFIRM_PASSWORD:
            textField.placeholder = @"请重新输入密码";
            textField.text = confirmPassword;
            textField.secureTextEntry = YES;
            break;
        
        default:
            break;
    }
	
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
//    if ([self.loginIdField.text length] <= 0){
//        return NO;
//    }
//    
//    if ([self.loginPasswordTextField.text length] <= 0){
//        return NO;
//    }
    
    return YES;
}

- (IBAction)clickRegister:(id)sender
{
    if ([self verifyField] == NO)
        return;
    
    UserService* userService = GlobalGetUserService();
    [userService registerUser:email password:password viewController:self];         
}

@end
