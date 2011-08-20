//
//  PPTableViewController.m
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-1.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "PPTableViewController.h"
#import "UITableViewCellUtil.h"
#import "ArrayOfCharacters.h"



@implementation PPTableViewController

@synthesize dataList;
@synthesize dataTableView;
@synthesize singleCellImage;
@synthesize firstCellImage;
@synthesize middleCellImage;
@synthesize lastCellImage;
@synthesize cellImage;
@synthesize groupData;
@synthesize cellTextLabelColor;
@synthesize accessoryView;
//@synthesize customIndexView;
@synthesize enableCustomIndexView;
@synthesize sectionImage;
@synthesize footerImage;
@synthesize sectionLabel;

@synthesize reloading=_reloading;
@synthesize refreshHeaderView;
@synthesize supportRefreshHeader;
@synthesize moreLoadingView;
@synthesize moreRowIndexPath;

@synthesize tappedIndexPath;
@synthesize controlRowIndexPath;

- (void)loadCellFromNib:(NSString*)nibFileNameWithoutSuffix 
{
    [[NSBundle mainBundle] loadNibNamed:nibFileNameWithoutSuffix owner:self options:nil];
}

#pragma mark Select Row And Section Methods

- (void)resetSelectRowAndSection
{
	selectRow = -1;
	selectSection = -1;
	oldSelectRow = -1;
	oldSelectSection = -1;
}

- (void)updateSelectSectionAndRow:(NSIndexPath*)indexPath
{
	oldSelectRow = selectRow;
	oldSelectSection = selectSection;
	
	selectRow = indexPath.row;
	selectSection = indexPath.section;
}

- (void)reloadForSelectSectionAndRow:(NSIndexPath*)indexPath
{
	if (oldSelectRow != -1 && oldSelectSection != -1){
		// reload previous selected row
		NSArray* oldRowIndexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:oldSelectRow inSection:oldSelectSection]];
		[dataTableView reloadRowsAtIndexPaths:oldRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
	}
	
	// reload new selected row
	[dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];  	
}

#pragma mark Table View Controller

- (void)createRefreshHeaderView
{
    if (!supportRefreshHeader)
        return;
    
    if (refreshHeaderView == nil) {
        self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.dataTableView.bounds.size.height, 320.0f, self.dataTableView.bounds.size.height)] autorelease];
        refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        refreshHeaderView.bottomBorderThickness = 1.0;
        [self.dataTableView addSubview:refreshHeaderView];
        self.dataTableView.showsVerticalScrollIndicator = YES;
    }
}

- (void)clearRefreshFlag
{
    needRefreshNow = NO;
}

- (void)viewDidLoad
{
    needRefreshNow = NO;
    
	dataTableView.delegate = self;
	dataTableView.dataSource = self;
	
	[self resetSelectRowAndSection];	
	[super viewDidLoad];
    [self createRefreshHeaderView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.refreshHeaderView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    if (needRefreshNow == YES){
        [self reloadTableViewDataSource];
//        [self.dataTableView scrollRectToVisible:refreshHeaderView.frame animated:YES];
        needRefreshNow = NO;
    }
    
	[dataTableView reloadData];	
	[super viewDidAppear:animated];
}

- (BOOL)isCellSelected:(NSIndexPath*)indexPath
{
	return (indexPath.row == selectRow && indexPath.section == selectSection);
}

- (int)dataListCountWithMore
{
    int count = [dataList count];
    if (count > 0){
        return count + 1;
    }
    else{
        return count;
    }    
}

- (BOOL)isMoreRow:(int)row
{
    return [dataList count] == row;
}

- (BOOL)isMoreRowIndexPath:(NSIndexPath*)indexPath
{
    if ([moreRowIndexPath isEqual:indexPath])
        return YES;
    else  
        return NO;
}

- (void)updateMoreRowIndexPath
{
    if ([self.dataList count] > 0)
        self.moreRowIndexPath = [NSIndexPath indexPathForRow:[dataList count] inSection:moreRowSection];
    else
        self.moreRowIndexPath = nil;
}

- (void)enableMoreRowAtSection:(int)section
{
    supportMoreRow = YES;
    moreRowSection = section;
    [self updateMoreRowIndexPath];
}

- (NSIndexPath*)modelIndexPathForIndexPath:(NSIndexPath*)indexPath
{
    if (controlRowIndexPath == nil){
        return indexPath;                    
    }    
    
    if ([indexPath isEqual:controlRowIndexPath]){
        return nil;
    }
    
    if (indexPath.section != controlRowIndexPath.section)
        return indexPath;
    
    if (indexPath.row < controlRowIndexPath.row){
        return indexPath;
    }
    else{
        return [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
}

- (BOOL)isControlRowIndexPath:(NSIndexPath*)indexPath
{
    return [controlRowIndexPath isEqual:indexPath];
}

- (void)deleteControlRow
{
    // delete control row and tap row
    if (controlRowIndexPath){
        
        [self updateMoreRowIndexPath];
        
        NSIndexPath* indexPathForDelete = [self.controlRowIndexPath retain];
        self.tappedIndexPath = nil;
        self.controlRowIndexPath = nil;
        
        [self.dataTableView beginUpdates];        
        [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForDelete] withRowAnimation:UITableViewRowAnimationFade];
        [self.dataTableView endUpdates];
        
        [indexPathForDelete release];
        
    }    
}

- (int)calcRowCount
{
    int count = [dataList count];
    if (controlRowIndexPath)
        count ++;
    
    if (count > 0 && supportMoreRow)
        count ++;
    
    return  count;
}

- (void)dealloc
{
    [refreshHeaderView release];
    [tappedIndexPath release];
    [controlRowIndexPath release];
    [moreRowIndexPath release];
    [moreLoadingView release];
	[groupData release];
	[dataList release];
	[dataTableView release];
	[firstCellImage release];
	[middleCellImage release];
	[lastCellImage release];
	[cellImage release];
	[singleCellImage release];
	[cellTextLabelColor release];
	[accessoryView release];
//	[customIndexView release];
	[sectionImage release];
	[sectionLabel release];
	[footerImage release];
	[super dealloc];
}

#pragma mark Image Methods

- (void)setSingleCellImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.singleCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	singleImageHeight = image.size.height;
}

- (void)setFirstCellImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.firstCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	firstImageHeight = image.size.height;
}

- (void)setMiddleCellImageByName:(NSString*)imageName;
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.middleCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	middleImageHeight = image.size.height;
}

- (void)setLastCellImageByName:(NSString*)imageName;
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.lastCellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	lastImageHeight = image.size.height;
}

- (void)setCellImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.cellImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	cellImageHeight = image.size.height;
}

- (void)setSectionImageByName:(NSString*)imageName
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.sectionImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	sectionImageHeight = image.size.height;
	
}

- (void)setFooterImageByName:(NSString*)imageName;
{
	UIImage* image = [UIImage imageNamed:imageName];
	self.footerImage = [[[UIImageView alloc] initWithImage:image] autorelease];
	footerImageHeight = image.size.height;	
}

- (CGFloat)getRowHeight:(int)row totalRow:(int)totalRow
{
	
	if (row == 0 && totalRow == 1)				// single
		return singleImageHeight - 1;
	else if (row == 0)							// first
		return firstImageHeight - 1;
	else if (row == (totalRow - 1))				// last
		return lastImageHeight;
	else
		return middleImageHeight;				// middle
}

- (void)setCellBackground:(UITableViewCell*)cell row:(int)row count:(int)count
{	
	// set background image
	if (row == 0 && count == 1)
		[cell setBackgroundImageByView:singleCellImage];
	else if (row == 0)
		[cell setBackgroundImageByView:firstCellImage];
	else if (row == (count - 1))
		[cell setBackgroundImageByView:lastCellImage];
	else
		[cell setBackgroundImageByView:middleCellImage];	
}

- (UIView*)getSectionView:(UITableView*)tableView section:(int)section
{
	if (sectionImage == nil)
		return nil;
	
	UILabel* textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, sectionImageHeight)] autorelease];
	textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	textLabel.font = [UIFont boldSystemFontOfSize:14];
	textLabel.textColor = [UIColor whiteColor];
	textLabel.backgroundColor = [UIColor clearColor];
	
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:sectionImage.image] autorelease];
	imageView.frame = CGRectMake(0, 0, sectionImage.image.size.width, sectionImage.image.size.height);
	
	UIView* sectionView = [[[UIView alloc] initWithFrame:imageView.frame] autorelease];
	[sectionView addSubview:imageView];
	[sectionView addSubview:textLabel];	
	
	return sectionView;
}

- (UIView*)getFooterView:(UITableView*)tableView section:(int)section
{
	if (footerImage == nil)
		return nil;
	
	UIImageView* imageView = [[[UIImageView alloc] initWithImage:footerImage.image] autorelease];
	return imageView;
}

#pragma mark ScrollView Callbacks for Pull Refresh

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
    if (!supportRefreshHeader)
        return;
    
	if (scrollView.isDragging) {        
#ifdef DEBUG        
        NSLog(@"point=%@", NSStringFromCGPoint(scrollView.contentOffset));
#endif        
		if (!_reloading && refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (!_reloading && refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    if (!supportRefreshHeader)
        return;
    
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		[self reloadTableViewDataSource];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.dataTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

#pragma mark -
#pragma mark refreshHeaderView Methods

- (void)dataSourceDidFinishLoadingNewData{
	
    if (!supportRefreshHeader)
        return;
    
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.dataTableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[refreshHeaderView setState:EGOOPullRefreshNormal];
}

#pragma mark For Sub Class to override and implement
- (void) reloadTableViewDataSource
{
	NSLog(@"Please override reloadTableViewDataSource");    
    
    // after finish loading data, please call the following codes
	[refreshHeaderView setCurrentDate];  	
	[self dataSourceDidFinishLoadingNewData];
    
}


#pragma mark Table View Delegate

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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	return [self getSectionView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return sectionImageHeight;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//	return [self getFooterView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return footerImageHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 55;
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
		
		if (cellTextLabelColor != nil)
			cell.textLabel.textColor = cellTextLabelColor;
		else
			cell.textLabel.textColor = [UIColor colorWithRed:0x3e/255.0 green:0x34/255.0 blue:0x53/255.0 alpha:1.0];
		
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0x84/255.0 green:0x79/255.0 blue:0x94/255.0 alpha:1.0];			
	}
	
	cell.accessoryView = accessoryView;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
	[self setCellBackground:cell row:row count:count];
	
	// NSObject* dataObject = [dataList objectAtIndex:row];
	// PPContact* contact = (PPContact*)[groupData dataForSection:indexPath.section row:indexPath.row];	
	
	return cell;
	
}

- (void)didSelectMoreRow
{
    NSLog(@"select more row, default implementation");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if ([self isMoreRowIndexPath:indexPath]){
        [self.moreLoadingView startAnimating];
        if ([self respondsToSelector:@selector(didSelectMoreRow)]){
            [self performSelector:@selector(didSelectMoreRow)];
        }
        
        // delete control row and tap row
        if (controlRowIndexPath){
            
            [self updateMoreRowIndexPath];
            
            NSIndexPath* indexPathForDelete = [self.controlRowIndexPath retain];
            self.tappedIndexPath = nil;
            self.controlRowIndexPath = nil;

            [self.dataTableView beginUpdates];        
            [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForDelete] withRowAnimation:UITableViewRowAnimationFade];
            [self.dataTableView endUpdates];

            [indexPathForDelete release];
            
        }
        return;
    }
    
    if ([indexPath isEqual:self.tappedIndexPath]){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    indexPath = [self modelIndexPathForIndexPath:indexPath];
    NSIndexPath* indexPathForDelete = [self.controlRowIndexPath retain];
    
    if ([indexPath isEqual:self.tappedIndexPath]){
        self.tappedIndexPath = nil;
        self.controlRowIndexPath = nil;
    }
    else{
        self.tappedIndexPath = indexPath;
        self.controlRowIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
    }        
    
    if (controlRowIndexPath)
        self.moreRowIndexPath = [NSIndexPath indexPathForRow:[dataList count]+1 inSection:moreRowSection];
    else
        [self updateMoreRowIndexPath];
    
    [self.dataTableView beginUpdates];        
    if (indexPathForDelete){                
        [self.dataTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForDelete] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (self.controlRowIndexPath){                
        [self.dataTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.controlRowIndexPath] withRowAnimation:UITableViewRowAnimationFade];        
    }    
    [self.dataTableView endUpdates];
    
    [indexPathForDelete release];
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // the code below is only valid when control row is used
    if ([indexPath isEqual:self.controlRowIndexPath]){
        return self.tappedIndexPath;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row > [dataList count] - 1)
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
