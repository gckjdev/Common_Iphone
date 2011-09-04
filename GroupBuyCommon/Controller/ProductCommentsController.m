//
//  ProductCommentsController.m
//  groupbuy
//
//  Created by penglzh on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductCommentsController.h"
#import "ProductWriteCommentController.h"
#import "GroupBuyNetworkConstants.h"
#import "TimeUtils.h"
#import "CommentTableViewCell.h"


@implementation ProductCommentsController

@synthesize productId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    supportRefreshHeader = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"评论";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeComment)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    
    //[GlobalGetProductService() getCommentsWithProductId:productId viewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadTableViewDataSource];
}

- (void)writeComment
{
    ProductWriteCommentController *controller = [[ProductWriteCommentController alloc] init];
    controller.productId = self.productId;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)getCommentFinish:(int)result jsonArray:(NSArray *)jsonArray
{
    self.dataList = jsonArray;
    [self.dataTableView reloadData];
    [refreshHeaderView setCurrentDate];  	
	[self dataSourceDidFinishLoadingNewData];
}

- (void) reloadTableViewDataSource
{
	[GlobalGetProductService() getCommentsWithProductId:productId viewController:self];
}

- (NSString*)getDateDisplayText:(NSDate*)date
{
    if (date == nil)
        return @"";
    
    int second = abs([date timeIntervalSinceNow]);
    
    if (second < 60){
        return [NSString stringWithFormat:NSLS(@"kDateBySecond"), second];
    }
    else if (second < 60*60){
        return [NSString stringWithFormat:NSLS(@"kDateByMinute"), second/(60)];        
    }
    else if (second < 60*60*24){
        return [NSString stringWithFormat:NSLS(@"kDateByHour"), second/(60*60)];                
    }
    else if (second < 60*60*24*3){
        return [NSString stringWithFormat:NSLS(@"kDateByDay"), second/(60*60*24)];                
    }
    else{
        return dateToStringByFormat(date, @"yyyy-MM-dd");                        
    }    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int index = [self.dataList count] - 1 - row;
    
    NSString *CellIdentifier = [CommentTableViewCell getCellIdentifier];
	CommentTableViewCell *cell = (CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [CommentTableViewCell createCell];
	}
    
    NSString *content = [[self.dataList objectAtIndex:index] objectForKey:PARA_COMMENT_CONTENT];
    NSString *nickName = [[self.dataList objectAtIndex:index] objectForKey:PARA_NICKNAME];
    NSNumber *interval = [[self.dataList objectAtIndex:index] objectForKey:PARA_CREATE_DATE];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:interval.doubleValue / 1000];
	
    [cell setCellInfoWithContent:content nickName:nickName createDate:createDate];
    
	return cell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = indexPath.row;
    int index = [self.dataList count] - 1 - row;
    
    NSString *CellIdentifier = [CommentTableViewCell getCellIdentifier];
	CommentTableViewCell *cell = (CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [CommentTableViewCell createCell];
	}
    
    NSString *content = [[self.dataList objectAtIndex:index] objectForKey:PARA_COMMENT_CONTENT];
    NSString *nickName = [[self.dataList objectAtIndex:index] objectForKey:PARA_NICKNAME];
    NSNumber *interval = [[self.dataList objectAtIndex:index] objectForKey:PARA_CREATE_DATE];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:interval.doubleValue / 1000];
	
    [cell setCellInfoWithContent:content nickName:nickName createDate:createDate];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
