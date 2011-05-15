//
//  TestPPViewController.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-2.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "TestPPViewController.h"


@implementation TestPPViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.dataList = [NSArray arrayWithObjects:@"Hello1", @"Hello2", @"Hello3", nil];
	
    [super viewDidLoad];
	
//	[self setBackgroundImage:@"blackbg.png"];
//	[self setFirstCellImageByName:@"topcellbg.png"];
//	[self setLastCellImageByName:@"lastcellbg.png"];
//	[self setMiddleCellImageByName:@"middlecellbg.png"];
//	[self setSingleCellImageByName:@"singlecellbg.png"];

//	[self setBackgroundImage:@"paperbg.png"];
	self.view.backgroundColor = [UIColor blackColor];
	[self setFirstCellImageByName:@"papertop_74.png"];
	[self setLastCellImageByName:@"paperlast_268.png"];
	[self setMiddleCellImageByName:@"papermiddle_60.png"];
	[self setSingleCellImageByName:@"paper_single334.png"];
	
	
}

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
	
	//return 60;
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
		cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
	[self setCellBackground:cell row:row count:count];
	
	cell.textLabel.text = [dataList objectAtIndex:row];
	// NSObject* dataObject = [dataList objectAtIndex:row];
	
	return cell;
	
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

@end
