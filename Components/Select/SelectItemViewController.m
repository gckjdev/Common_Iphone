//
//  SelectItemViewController.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-4.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "SelectItemViewController.h"


@implementation SelectItemViewController

@synthesize delegate;
@synthesize inputSelectRow;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)setInputSelectRow:(int)row
{
	inputSelectRow = row;
	itemSelectRow = row;
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
	return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataList count];			// default implementation
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
//		cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
//		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
		if (cellTextLabelColor != nil)
			cell.textLabel.textColor = cellTextLabelColor;
		
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
	[self setCellBackground:cell row:row count:count];
	
	NSObject* dataObject = [dataList objectAtIndex:row];
	if ([dataObject isKindOfClass:[NSString class]]){
		cell.textLabel.text = (NSString*)dataObject;
	}
	else if ([dataObject respondsToSelector:@selector(textForCellDisplay)]){
		cell.textLabel.text = [dataObject performSelector:@selector(textForCellDisplay)];
	}else {
		cell.textLabel.text = [dataObject description];
	}
	
	if (itemSelectRow == row){
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.accessoryView = accessoryView;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.accessoryView = nil;
	}

	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < 0 || indexPath.row > [dataList count] - 1)
		return;
	
	itemSelectRow = indexPath.row;	
	if (self.delegate && [delegate respondsToSelector:@selector(shouldContinueAfterRowSelect:)]){
		if ([self.delegate shouldContinueAfterRowSelect:itemSelectRow] == YES){
			[self.navigationController popViewControllerAnimated:YES];
		}
	}	
	
	[dataTableView reloadData];
}

@end
