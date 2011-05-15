//
//  UIExtTableView.m
//  Test
//
//  Created by Peng Lingzhe on 5/31/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import "UIExtTableView.h"


@implementation UIExtTableView

@synthesize delegate, minRowNumber, maxRowNumber, tableView;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if ((self = [super initWithFrame:frame])) {		
		self.tableView	= [[UITableView alloc] initWithFrame:self.bounds style:style];
		self.tableView.delegate	= self;
		self.tableView.dataSource = self;
		self.tableView.backgroundColor = [UIColor clearColor];
		[self addSubview:tableView];
		
		minRowNumber = 1;	// default is 1
		maxRowNumber = 5;	// defatul is 5
    }
    return self;
}

- (BOOL)isFirstRow:(NSIndexPath*)indexPath
{	
	int row = [indexPath row];
	if (row == 0){
		return YES;
	}
	else {
		return NO;
	}

	
}

- (BOOL)isLastRow:(NSIndexPath*)indexPath
{
	int realRow = [delegate tableView:tableView numberOfRowsInSection:0];
	int extraRow = (realRow < maxRowNumber) ? (maxRowNumber - realRow) : minRowNumber;
	
	int row = [indexPath row];
	if (row == (realRow + extraRow - 1)){
		return YES;
	}
	else {
		return NO;
	}
}

- (BOOL)isMiddelRow:(NSIndexPath*)indexPath
{
	int realRow = [delegate tableView:tableView numberOfRowsInSection:0];
	int extraRow = (realRow < maxRowNumber) ? (maxRowNumber - realRow) : minRowNumber;
	
	int row = [indexPath row];
	if (row > 0 && row < (realRow + extraRow - 1)){
		return YES;
	}
	else {
		return NO;
	}
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	NSLog(@"numberOfSectionsInTableView");
	
    return 1;	// only support one section 
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {	
	
	
	NSLog(@"numberOfRowsInSection");
	
	if (delegate != nil && [delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
		int realRow = [delegate tableView:tableView numberOfRowsInSection:0];
		if (realRow < maxRowNumber){
			return maxRowNumber;
		}
		else {
			return realRow + minRowNumber;
		}		
	}
	
    return 0;
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSLog(@"heightForRowAtIndexPath");
	
	if (delegate == nil || 
		![delegate respondsToSelector:@selector(tableView:heightForExtraRowAtIndexPath:)] ||
		![delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)] ||
		![delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]
		)
		return 0;
	
	if (theTableView != tableView)
		return 0;
	
	int row = [indexPath row];	
	int realRow = [delegate tableView:tableView numberOfRowsInSection:0];
	if (row >=0 && row < realRow){
		return [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	else{
		return [delegate tableView:tableView heightForExtraRowAtIndexPath:indexPath];
	}			
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSLog(@"cellForRowAtIndexPath");	
	
	if (delegate == nil || 
		![delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)] ||
		![delegate respondsToSelector:@selector(tableView:cellForExtraRowAtIndexPath:)] ||
		![delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]
		)
		return 0;
	
	if (theTableView != tableView)
		return 0;
	
	int row = [indexPath row];	
	int realRow = [delegate tableView:tableView numberOfRowsInSection:0];	
	if (row >=0 && row < realRow){
		return [delegate tableView:tableView cellForRowAtIndexPath:indexPath];
	}
	else{
		return [delegate tableView:tableView cellForExtraRowAtIndexPath:indexPath];
	}			

}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */



- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

	int row = [indexPath row];	
	int realRow = [delegate tableView:tableView numberOfRowsInSection:0];		
	if (row >=0 && row < realRow){
		return [delegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
	else{
		return [delegate tableView:tableView commitEditingStyle:editingStyle forExtraRowAtIndexPath:indexPath];
	}		
	
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	int row = [indexPath row];	
	int realRow = [delegate tableView:tableView numberOfRowsInSection:0];		
	if (row >=0 && row < realRow){
		return [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
	else{
		return [delegate tableView:tableView didSelectExtraRowAtIndexPath:indexPath];
	}		
}


#pragma mark -
#pragma mark Memory management

- (void)reloadData
{
	[tableView reloadData];
}

- (void)dealloc {
	[tableView release];
    [super dealloc];
}



@end
