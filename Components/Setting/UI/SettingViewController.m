//
//  SettingViewController.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingGroup.h"
#import "SettingOptionValue.h"
#import "SettingManager.h"
#import "SettingDefinition.h"
#import "SettingDefinitionManager.h"
#import "SelectItemViewController.h"
#import "TextEditorViewController.h"
#import "Setting.h"

@implementation SettingViewController

@synthesize currentSettingDefinition;
@synthesize allGroups;

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
	
	self.allGroups = [SettingDefinitionManager getAllSettingGroups];
	
	//[SettingManager setStringValue:@"PIPI" forKey:@"allowLogin2"];
	
    [super viewDidLoad];
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
	[currentSettingDefinition release];
	[allGroups release];
    [super dealloc];
}

#pragma mark Table View Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	SettingGroup* group = [allGroups objectAtIndex:section];
	NSString *sectionHeader = [group localizedName];	
	
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
	
	return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [allGroups count];		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	SettingGroup* group = [allGroups objectAtIndex:section];
	return [group.settingDefinitions count];			// default implementation
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//		cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
//		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
	}
	
	// set text label
	int row = [indexPath row];	
	SettingGroup* group = [allGroups objectAtIndex:indexPath.section];	
	int count = [group.settingDefinitions count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
//	[self setCellBackground:cell row:row count:count];
	SettingDefinition* sd = [group getSettingDefinition:row];
	
	cell.textLabel.text = [sd localizedName];
	cell.detailTextLabel.text = [SettingManager getStringValue:sd.key];
	
	return cell;
	
}

- (BOOL)shouldContinueAfterRowSelect:(int)row
{
	NSLog(@"selected row is %d", row);
	
	if (currentSettingDefinition == nil){
		NSLog(@"shouldContinueAfterRowSelect, but currentSettingDefinition is nil");
		return NO;
	}
	
	// update data by key
	if ([currentSettingDefinition isBoolType]){
		if (row == kRowOn){
			// ON
			[SettingManager setBoolValue:YES forKey:currentSettingDefinition.key];
		}
		else {
			// OFF
			[SettingManager setBoolValue:NO forKey:currentSettingDefinition.key];
		}
	}
	else if ([currentSettingDefinition isListType]){
		NSArray* valueArray = [currentSettingDefinition getOptionStringValues];
		if (row >=0 && row < [valueArray count]){
			// set value by selected row			
			SettingOptionValue* value = [valueArray objectAtIndex:row];
			[SettingManager setStringValue:value.optionValue forKey:currentSettingDefinition.key];
		}
	}
	
	
	
	return NO;
}

- (void)textChanged:(NSString*)newText;
{
	if (currentSettingDefinition == nil){
		NSLog(@"shouldContinueAfterRowSelect, but currentSettingDefinition is nil");
		return;
	}	
	
	[SettingManager setStringValue:newText forKey:currentSettingDefinition.key];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section < 0 || indexPath.section > [allGroups count] - 1)
		return;

	SettingGroup* group = [allGroups objectAtIndex:indexPath.section];
	int count = [group.settingDefinitions count];
	if (indexPath.row >= count){
		return;
	}
	
	self.currentSettingDefinition = [group getSettingDefinition:indexPath.row];	
	
	if ([currentSettingDefinition isStringType]){
		// use TextEditorViewController
		TextEditorViewController* vc = [[TextEditorViewController alloc] init];
		vc.delegate = self;
		vc.inputText = [SettingManager getStringValue:currentSettingDefinition.key];		
		if ([currentSettingDefinition requireSingleLine]){
			vc.isSingleLine = YES;
		}
		vc.backgroundImageName = self.backgroundImageName;
		
		[self.navigationController pushViewController:vc animated:YES];
		[vc release];
	}
	else if ([currentSettingDefinition isListType]){
		// use SelectItemViewController
		NSString* stringValue = [SettingManager getStringValue:currentSettingDefinition.key];
		
		NSArray* valueArray = [currentSettingDefinition getOptionStringValues];
		SelectItemViewController* vc = [[SelectItemViewController alloc] init];
		vc.delegate = self;
		vc.dataList = valueArray;
		vc.backgroundImageName = self.backgroundImageName;
		
		int  selectedRow = 0;
		BOOL found = NO;
		for (SettingOptionValue* option in valueArray){
			if ([option.optionValue caseInsensitiveCompare:stringValue] == NSOrderedSame){
				found = YES;
				break;
			}
			selectedRow++;
		}
		
		if (found){
			vc.inputSelectRow = selectedRow;
		}
		else {
			vc.inputSelectRow = kUnknownSelectRow;
		}
		
		[self.navigationController pushViewController:vc animated:YES];
		[vc release];
		
		
	}
	else if ([currentSettingDefinition isBoolType]){
		// use SelectItemViewController
		
		BOOL boolValue = [SettingManager getBoolValue:currentSettingDefinition.key];
		NSArray* valueArray = [NSArray arrayWithObjects:kOnString, kOffString, nil];
		SelectItemViewController* vc = [[SelectItemViewController alloc] init];
		vc.delegate = self;
		vc.dataList = valueArray;
		vc.backgroundImageName = self.backgroundImageName;
		
		if (boolValue){
			vc.inputSelectRow = 0;
		}
		else {
			vc.inputSelectRow = 1;
		}
		
		[self.navigationController pushViewController:vc animated:YES];
		[vc release];
		
	}
	else if ([currentSettingDefinition isIntType]){
		// use TextEditorViewController 
		TextEditorViewController* vc = [[TextEditorViewController alloc] init];
		vc.delegate = self;
		vc.inputText = [SettingManager getStringValue:currentSettingDefinition.key];		
		vc.isNumber = YES;
		vc.isSingleLine = YES;
		vc.backgroundImageName = self.backgroundImageName;		
		
		[self.navigationController pushViewController:vc animated:YES];
		[vc release];	
	}	
	
	// do select row action
	// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row < 0 || indexPath.row > [allGroups count] - 1)
			return;
		
		// take delete action below, update data list
		// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];		
		
		// update table view
		
	}
	
}


@end
