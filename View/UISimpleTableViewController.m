//
//  UISimpleTableViewController.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "UISimpleTableViewController.h"

@implementation UISimpleTableViewController

@synthesize idArray;
@synthesize titleArray;
@synthesize selectedId;
@synthesize selectedIndexPath;
@synthesize action;

- (id)initWithStyle:(UITableViewStyle)style idArray:(NSArray *)aIdArray titleArray:(NSArray *)aTitleArray selectedId:(NSObject *)aSelectedId
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		self.idArray = aIdArray;
		self.titleArray = aTitleArray;
		self.selectedId = aSelectedId;
		self.action = [[ActionSelector alloc] init];

		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickCancel:)];
    }
    return self;
}

- (void)setDoneTarget:(id)target selector:(SEL)selector
{
	action.target = target;
	action.selector = selector;
}

- (void)clickCancel:(id)sender
{
	[self.nav popViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (void)switchCheckCell:(UITableView *)tableView oldIndexPath:(NSIndexPath *)oldIndexPath newIndexPath:(NSIndexPath *)newIndexPath
{
	if (oldIndexPath == newIndexPath)
		return;
	
	UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:oldIndexPath];
	UITableViewCell *newSelectedCell = [tableView cellForRowAtIndexPath:newIndexPath];
	
	// set cell check mark
	oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;
	newSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSUInteger row = [indexPath row];
	
    // Set up the cell text
	cell.textLabel.text = [titleArray objectAtIndex:row];
	
	// Set up check mark
	if ([[idArray objectAtIndex:row] isEqual:self.selectedId]){
		cell.accessoryType = UITableViewCellAccessoryCheckmark;

		// set selected index path
		self.selectedIndexPath = indexPath;
		
		self.selectedId = [idArray objectAtIndex:row];
	}
	else{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	

	NSLog(@"didSelectRowAtIndexPath");
	
	if (self.selectedIndexPath != indexPath){
	
		// unmark old selected row and mark new selected row
		[self switchCheckCell:tableView oldIndexPath:selectedIndexPath newIndexPath:indexPath];
	
		// set selected index path
		self.selectedIndexPath = indexPath;
	
		// set selected category data (for return)
		self.selectedId = [idArray objectAtIndex:[indexPath row]];
		
		NSLog(@"selected ID is %@", self.selectedId);
				
		[self.nav popViewControllerAnimated:YES];
		
		// execute action
		[action perform:self];

	}
}

- (void)dealloc {
	
	[idArray release];
	[titleArray release];
	[selectedId release];
	[selectedIndexPath release];
	[action release];
	
    [super dealloc];
}


@end

