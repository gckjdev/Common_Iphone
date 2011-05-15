//
//  SelectGroupController.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-2-13.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "SelectGroupController.h"
#import "AddressBookUtils.h"

@implementation SelectGroupController

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

- (id)initWithDelegate:(id<SelectGroupControllerDelegate>)delegateValue
{
	if (self = [super init]){
		delegate = delegateValue;
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
		
//	[self setNavigationLeftButton:NSLS(@"Back") imageName:@"barbutton.png" action:@selector(clickBack:)];
	
    [super viewDidLoad];
	self.dataList = [AddressBookUtils queryAllGroup:addressBook];
	
	if ([self.dataList count] > 0){
		[self.dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [super dealloc];
}

#pragma mark Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
//{
//	NSMutableArray* array = [NSMutableArray arrayWithArray:[ArrayOfCharacters getArray]];
//	[array addObject:kSectionNull];
//	return array;
//	
////		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
////		return nil;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [groupData sectionForLetter:title];
//}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	
	
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
	int height = [self getRowHeight:indexPath.row totalRow:[dataList count]];
//	NSLog(@"<debug> height = %d", height);
	return height;
	// return cellImageHeight;
	
	// return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
	
	// return [groupData totalSectionCount];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataList count];			// default implementation
	
	// return [groupData numberOfRowsInSection:section];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
		cell.textLabel.textColor = [UIColor colorWithRed:130/255.0 green:111/255.0 blue:95/255.0 alpha:1.0];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
//		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
	[self setCellBackground:cell row:row count:count];
	
	PPGroup* group = [dataList objectAtIndex:row];
	cell.textLabel.text = group.name;
	
	// PPContact* contact = (PPContact*)[groupData dataForSection:indexPath.section row:indexPath.row];	
	
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < 0 || indexPath.row > [dataList count] - 1)
		return;
	
	// do select row action
	PPGroup* group = [dataList objectAtIndex:indexPath.row];
	if (group != nil){
		if (delegate != nil && [delegate respondsToSelector:@selector(groupSelect:)]){
			[delegate groupSelect:group.groupId];
		}
	}
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

@end
