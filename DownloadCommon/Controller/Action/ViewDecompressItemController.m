//
//  ViewDirectoryController.m
//  Download
//
//  Created by gckj on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewDecompressItemController.h"
#import "FileUtil.h"
#import "DownloadService.h"
#import "LogUtil.h"
#import "DecompressItem.h"
#import "DecompressService.h"

@implementation ViewDecompressItemController

@synthesize decompressItemList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [decompressItemList release];
    [super release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self loadDataFromDecompressArray];
    [self.dataTableView reloadData];
}

- (void) loadDataFromDecompressArray
{    
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (DecompressItem *item in decompressItemList) {
        [array addObject:item.fileName];
    }
    self.dataList = array;
}

- (NSArray *) findAllDecompressImage
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    for (DecompressItem *item in decompressItemList) {
        if ([item isImage]) {
            [array addObject:item];
        }
    }
    return array;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ViewDecompressItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.dataList objectAtIndex:row];
        
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > [dataList count] - 1)
		return;
    NSUInteger row = indexPath.row;
    
    DecompressItem* item = [decompressItemList objectAtIndex:row];
    DecompressService *service = [DecompressService defaultService];
    
    if ([item isImage]) {
        NSArray *imageList = [self findAllDecompressImage];
        int indexValue = [imageList indexOfObject:item];
        [service playItem:imageList index:indexValue viewController:self];
    }
    else{
        [service playItem:item viewController:self];
    }
    
}

@end
