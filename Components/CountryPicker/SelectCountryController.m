//
//  SelectCountryController.m
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-2.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "SelectCountryController.h"
#import "CountryDataManager.h"

#define kFontSize 15

@implementation SelectCountryController

@synthesize selectedCountryLocalizedName;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.dataList = [[CountryDataManager manager] getAllData];
	self.groupData = [GroupDataAZ GroupDataWithArray:self.dataList];
	
	self.view.backgroundColor = [UIColor whiteColor];
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
	[selectedCountryLocalizedName release];
    [super dealloc];
}

#pragma mark Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	//	return nil;
	return [self getSectionView:tableView section:section];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return sectionImageHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if ([groupData totalSectionCount] == section + 1)
		return nil;
	
	return [self getFooterView:tableView section:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return footerImageHeight;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
{
	NSMutableArray* array = [NSMutableArray arrayWithArray:[ArrayOfCharacters getArray]];
	[array addObject:kSectionNull];
	return array;
	
//		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
//		return nil;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [groupData sectionForLetter:title];
}

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
	return [self getRowHeight:indexPath.row totalRow:[groupData numberOfRowsInSection:indexPath.section]];
	// return cellImageHeight;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [groupData totalSectionCount];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [groupData numberOfRowsInSection:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.textLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
		cell.textLabel.textColor = [UIColor colorWithRed:130/255.0 green:111/255.0 blue:95/255.0 alpha:1.0];
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
	[self setCellBackground:cell row:row count:count];
	
	CountryData* dataObject = (CountryData*)[groupData dataForSection:indexPath.section row:indexPath.row]; //[dataList objectAtIndex:row];
	NSString* countryLocalizedName = [[CountryDataManager manager] localizedNameFromData:dataObject.jsonData];	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ (+%@)",	
						   countryLocalizedName,
						   [[CountryDataManager manager] countryTelPrefixFromData:dataObject.jsonData]];
	
	if ([countryLocalizedName isEqualToString:selectedCountryLocalizedName]){
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else{
		cell.accessoryType = UITableViewCellAccessoryNone;		
	}
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < 0 || indexPath.row > [dataList count] - 1)
		return;
	
	// do select row action
	CountryData* dataObject = (CountryData*)[groupData dataForSection:indexPath.section row:indexPath.row];
	NSString* countryLocalizedName = [[CountryDataManager manager] localizedNameFromData:dataObject.jsonData];	
	NSString* countryTelPrefix = [[CountryDataManager manager] countryTelPrefixFromData:dataObject.jsonData];
	NSString* countryCode = [[CountryDataManager manager] countryCodeFromData:dataObject.jsonData];
	
	if (delegate && [delegate respondsToSelector:@selector(didSelectCountry:countryTelPrefix:countryCode:)]){
		[delegate didSelectCountry:countryLocalizedName countryTelPrefix:countryTelPrefix countryCode:countryCode];
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
@end
