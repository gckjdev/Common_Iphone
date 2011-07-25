//
//  ProductDetailController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailController.h"
#import "Product.h"
#import "PPWebViewController.h"

enum {
    SECTION_TITLE,
    SECTION_IMAGE,
    SECTION_DESC,
    SECTION_DATE,
    SECTION_SHOP_ADDRESS,
    SECTION_MORE,
    SECTION_NUM    
};

@implementation ProductDetailController

@synthesize product;
@synthesize priceLabel;
@synthesize rebateLabel;
@synthesize saveLabel;
@synthesize boughtLabel;

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
    [product release];
    [priceLabel release];
    [rebateLabel release];
    [saveLabel release];
    [boughtLabel release];
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
    self.boughtLabel.text = [product.bought description];
    self.rebateLabel.text = [product.rebate description];
    self.priceLabel.text = [product.price description];
    self.saveLabel.text = [[NSNumber numberWithDouble:([product.value doubleValue] - [product.price doubleValue])] description];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPriceLabel:nil];
    [self setRebateLabel:nil];
    [self setSaveLabel:nil];
    [self setBoughtLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
	
	return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_NUM;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;								
	}

	switch (indexPath.section) {
        case SECTION_TITLE:
            cell.textLabel.text = product.title;
            break;
            
        case SECTION_IMAGE:
            break;
            
        case SECTION_DESC:
//            cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", product.desc, product.detail];
            break;
            
        case SECTION_DATE:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"开始时间:%@\n结束时间:%@", 
                                   [product.startDate description], [product.endDate description]];
        }
            break;
            
        case SECTION_SHOP_ADDRESS:
        {
        }
            break;
            
        case SECTION_MORE:
        {
            cell.textLabel.text = @"更多商品详情信息";
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
}

- (IBAction)clickBuy:(id)sender
{
    TTWebController* webController = GlobalGetWebController();
    [self.navigationController pushViewController:webController animated:YES];
    [webController openURL:[NSURL URLWithString:product.loc]];
}

@end
