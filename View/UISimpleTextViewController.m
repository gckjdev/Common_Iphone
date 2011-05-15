//
//  UISimpleTextViewController.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UISimpleTextViewController.h"
#import "UITextTableViewCell.h"

@implementation UISimpleTextViewController

@synthesize placeHolder;
@synthesize inputText;
//@synthesize action;

- (id)initWithStyle:(NSString *)aPlaceHolder defaultText:(NSString *)defaultText aKeyboardType:(UIKeyboardType)aKeyboardType frame:(CGRect)frame
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.placeHolder = [NSString stringWithString:aPlaceHolder];
		self.inputText = [NSString stringWithString:defaultText];
		self.view.frame = frame;
		keyboardType = aKeyboardType;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SimpleTextViewTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

		UITextTableViewCell* textCell	= (UITextTableViewCell*)cell;
		
		textCell.textField.placeholder	= self.placeHolder;
		textCell.textField.keyboardType = keyboardType;
		textCell.textField.tag			= kDefaultSimpleTextViewTag;
		
		/*
		CGRect rect = tableView.frame;

		UITextView *textView = [[UITextField alloc] initWithFrame:rect];
		
//		textView. clearsOnBeginEditing = NO;
		//textView.placeholder = placeHolder;
		textView.returnKeyType = UIReturnKeyDone;
		textView.tag = kDefaultSimpleTextViewTag;
		//textView.delegate = self;
		
		[textView addTarget:self action:@selector(textInputDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		textView.font = [UIFont boldSystemFontOfSize:kSimpleTextTableViewFontSize];		
		 */
		
    }
    
	// set cell information
	
	UITextView* view = (UITextView*) [tableView viewWithTag:kDefaultSimpleTextViewTag];
	view.text = self.inputText;
		
    return cell;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	NSLog(@"textViewShouldEndEditing");		
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSLog(@"textViewDidEndEditing");	
}


- (void)textInputDone:(UITextView *)textView
{
	//UITextView* view = (UITextView*)sender;
	self.inputText = textView.text;
	
	NSLog(@"textInputDone");
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[placeHolder release];
	[inputText release];
//	[action release];
    [super dealloc];
}


@end
