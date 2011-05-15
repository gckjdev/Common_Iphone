//
//  UISearchHistoryView.m
//  three20test
//
//  Created by qqn_pipi on 10-4-6.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UISearchHistoryView.h"
#import "UIFontExt.h"
#import "UIViewUtils.h"
#import "UIUtils.h"

@implementation UISearchHistoryItem

@synthesize name;


- (id)initWithName:(NSString*)theName
{
	if (self = [super init]){
		self.name = theName;
	}
	
	return self;
}

- (void)dealloc
{
	[name release];
	
	[super dealloc];
}

@end


@implementation UISearchHistoryView

@synthesize tbView, searchHistoryList, delegate, clearHistoryButton, backButton;

- (int)getMaxTableHeight
{
	return (self.frame.size.height - kHistoryButtonHeight - kHistoryButtonTableLongestPadding - kHistoryTableBottomPadding);
}

- (id)initWithFrame:(CGRect)frame historyList:(NSMutableArray*)historyList
{
	if (self = [super initWithFrame:frame]){
		// add table view
		
		self.searchHistoryList = historyList;
		[self createButton];		
		
		CGRect tableFrame = frame;
		tableFrame.size.height = [self getMaxTableHeight];
		
		self.tbView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
		self.tbView.delegate = self;
		self.tbView.dataSource = self;
		self.tbView.backgroundColor = [UIColor clearColor];
		
		[self addSubview:self.tbView];		
		[self bringSubviewToFront:clearHistoryButton];
		[self bringSubviewToFront:backButton];
		
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
		
		[self updateButtonFrame];
	}
	
	return self;
}

- (void)createButton
{
	static int kFontSize = 14;
	
	static int kClearHistoryButtonWidth	 = 200; 
	static int kBackButtonWidth = 90;
	
	
	int left = 10;
	int top = 0;	
	top = [self getButtonTop];

	
	CGRect clearHistoryButtonRect = CGRectMake(left, top, kClearHistoryButtonWidth, kHistoryButtonHeight);
	
	self.clearHistoryButton	= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	clearHistoryButton.frame = clearHistoryButtonRect;
	[clearHistoryButton setTitle:kInfoClearHistory forState:UIControlStateNormal];
	clearHistoryButton.titleLabel.font = [UIFont coolFontBoldWithSize:kFontSize];
//	[clearHistoryButton setImage:[UIImage imageNamed:kCallButtonImage] forState:UIControlStateNormal];
	[clearHistoryButton addTarget:self action:@selector(clickClearHistory:) forControlEvents:UIControlEventTouchUpInside];			
	
	CGRect backButtonRect = CGRectMake(left + kClearHistoryButtonWidth + 10, top, kBackButtonWidth, kHistoryButtonHeight);
	
	self.backButton	= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	backButton.frame = backButtonRect;
	[backButton setTitle:kInfoBack forState:UIControlStateNormal];
	backButton.titleLabel.font = [UIFont coolFontBoldWithSize:kFontSize];		
//	[backButton setImage:[UIImage imageNamed:kCancelButtonImage] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];	
	
	[self addSubview:clearHistoryButton];
	[self addSubview:backButton];	

	/*
	if ([searchHistoryList count] > 0){
		clearHistoryButton.enabled = YES;		
	}
	else {
		clearHistoryButton.enabled = NO;
	}
	*/
	
}

- (int)getButtonTop
{
	int top;
	
	if ([searchHistoryList count] > 0){	
		
		top = [searchHistoryList count] * kHistoryCellHeight + kHistoryTablePadding + kHistoryButtonTableLongestPadding;
		if ( top + kHistoryButtonHeight + kHistoryTableBottomPadding > self.frame.size.height ){
			top = [self getMaxTableHeight] + kHistoryButtonTableLongestPadding;
		}		
		else {
			top = [searchHistoryList count] * kHistoryCellHeight + kHistoryTablePadding + kHistoryButtonTableNormalPadding;
		}

	}
	else {
		
		top = kHistoryButtonTableNoRecordPadding;		
	}

	return top;
}

- (void)updateButtonFrame
{
	CGRect rect = clearHistoryButton.frame;	
	rect.origin.y = [self getButtonTop];
	clearHistoryButton.frame = rect;
	
	rect = backButton.frame;	
	rect.origin.y = [self getButtonTop];	
	backButton.frame = rect;
	
}

- (void)updateView
{
	[self.tbView reloadData];	
	[self updateButtonFrame];
	
	/*
	if ([searchHistoryList count] > 0){
		clearHistoryButton.enabled = YES;		
	}
	else {
		clearHistoryButton.enabled = NO;
	}
	*/

}

#pragma mark Keyboard Methods

- (void)keyboardDidShow:(NSNotification *)notification
{
	// get keyboard frame
	NSDictionary* info = [notification userInfo];
	NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];	
    CGRect keyboardRect;
    [value getValue:&keyboardRect];
		
	
	// adjust height 
	// x is fixed : 0, width is fixed, y is given by initialize frame, so the only adjustment is height
	CGRect tableFrame = CGRectMake(self.superview.bounds.origin.x, self.frame.origin.y, 
								   self.superview.bounds.size.width, 480 - keyboardRect.size.height - kSearchBarHeight - 25);
	
	self.tbView.frame = tableFrame;	
	
//	[self.tableView scrollToRowAtIndexPath:self.currentTextCellIndexPath 
//						  atScrollPosition:UITableViewScrollPositionTop animated:YES];	
	
}

- (void)keyboardDidHide:(NSNotification *)notification
{
	NSDictionary* info = [notification userInfo];
	NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];	
    CGRect keyboardRect;
    [value getValue:&keyboardRect];
	
	// adjust height 
	// x is fixed : 0, width is fixed, y is given by initialize frame, so the only adjustment is height	
	CGRect tableFrame = CGRectMake(self.superview.bounds.origin.x, self.frame.origin.y, 
								   self.superview.bounds.size.width, 480-kSearchBarHeight-kTabBarHeight-kNavigationBarHeight);	
	
	self.tbView.frame = tableFrame;	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSearchHistorySectionNum;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case kSearchHistorySectionText:
			return [searchHistoryList count];
		case kSearchHistorySectionClear:
			if (searchHistoryList && [searchHistoryList count] > 0){
				return 1;
			}
			else {
				return 0;
			}

		default:
			break;
	}
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == kSearchHistorySectionText)
		return kHistoryCellHeight;
	else {
		return kHistoryCellHeight;
	}

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellSearchText";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Set up the cell...
	int row = [indexPath row];
	int section = [indexPath section];
	
	switch (section) {
		case kSearchHistorySectionText:
			if (row < [searchHistoryList count]){
				cell.textLabel.text = [searchHistoryList objectAtIndex:row];
			}
			cell.textLabel.font = [UIFont coolFontWithSize:14];
			cell.textLabel.textAlignment = UITextAlignmentLeft;
			break;
		case kSearchHistorySectionClear:
			cell.textLabel.text = kInfoClearHistory;
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.font = [UIFont coolFontBoldWithSize:14];
			break;

		default:
			break;
	}
	
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	int row = [indexPath row];
	int section = [indexPath section];
	
	switch (section) {
		case kSearchHistorySectionText:
			return UITableViewCellEditingStyleDelete;
			break;
		case kSearchHistorySectionClear:
			return UITableViewCellEditingStyleNone;
			break;
			
		default:
			return UITableViewCellEditingStyleNone;
	}	
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"deletion detected");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
				
		
		int row = [indexPath row];
		if (row < [searchHistoryList count]){
			
						
			[self.delegate didDeleteItem:[self.searchHistoryList objectAtIndex:row] 
								 atIndex:row];
			
			[self.searchHistoryList removeObjectAtIndex:row];
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];

			[self updateButtonFrame];
		}
				
	}
}

- (void)clickClearHistory:(id)sender
{	
	[UIUtils askYesNo:kInfoConfirmClearHistory cancelButtonTitle:kInfoClearHistoryNo okButtonTitle:kInfoClearHistoryYes delegate:self];	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1){
		[self.delegate didClearAllItem];		
		[self updateView];
	}
}

- (void)clickBack:(id)sender
{
	[self.delegate didClickBack];	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
//	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	
	int row = [indexPath row];
	int section = [indexPath section];
	
	switch (section) {
		case kSearchHistorySectionClear:
			[self.delegate didClearAllItem];
			break;
		case kSearchHistorySectionText:
			[self.delegate didSelectItem:[self.searchHistoryList objectAtIndex:row] 
								 atIndex:row];
			break;
			
		default:
			break;
	}

	
}


- (void)dealloc
{
	
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];	
	
	[tbView release];
	[searchHistoryList release];
	[delegate release];
	[clearHistoryButton release];
	[backButton release];
	
	[super dealloc];
}


@end
