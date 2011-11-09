//
//  ShowAddressViewController.m
//  AddressList
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShowAddressViewController.h"
#import "AnnotationPin.h"
#import "MapViewUtil.h"
#import "UITableViewCellUtil.h"

@implementation ShowAddressViewController
@synthesize mapView;
@synthesize tableView;
@synthesize locationArray;
@synthesize addressList;
@synthesize useForGroupBuy;

- (id)initWithLocationArray:(NSArray *)aLocationArray addressList: (NSArray *)aAddressList{
    self = [super init];
    if (self) {
        self.addressList = aAddressList;
        self.locationArray = aLocationArray;
    }
    return self;
}

- (void)dealloc
{
    [locationArray release];
    [addressList release];
    [mapView release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.useForGroupBuy){                
        if (!CGRectIsEmpty(self.tableViewFrame)){
            self.tableView.frame = self.tableViewFrame;
            self.mapView.frame = self.tableViewFrame;
        }
        
        self.tableView.backgroundColor = [UIColor clearColor];
        [self setGroupBuyNavigationTitle:@"商家地址信息"];
    }
    else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onclickBack:)];
    }
    
    
    
    
    BOOL locationFlag = (locationArray && [locationArray count] > 0) ? YES : NO;
    BOOL addressFlag = (addressList && [addressList count] > 0) ? YES : NO;
    
    
    if (!locationFlag && !addressFlag) {
        [self popupUnhappyMessage:@"当前没有任何商家地址信息" title:nil];
        return;
    }
        
    if (locationFlag) {
        //[self.tableView setHidden:YES];
        self.mapView.delegate = self;        
        [self.mapView setZoomEnabled:YES]; 
        [self.mapView setScrollEnabled:YES];         
        [self.mapView setCenterCoordinate:[[locationArray objectAtIndex:0] coordinate] 
                                zoomLevel:15 animated:YES];
        
        for (int i = 0; i < [self.locationArray count]; ++i) {
            CLLocation *location = [self.locationArray objectAtIndex:i];
            NSString *title = @"无地址详细信息";
            if ([self.addressList count] > i) {
                title = [self.addressList objectAtIndex:i];
            }
            AnnotationPin *pin = [[AnnotationPin alloc] initWithCoordinate:[location coordinate] title:title subtitle:nil];
            [self.mapView addAnnotation:pin];
            [pin release];
        }
    }
    if (addressFlag) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    if (locationFlag) {
        [self setGroupBuyNavigationRightButton:@"列表" action:@selector(clickRightButton:)];
        self.navigationItem.title = @"地图";
        [self.mapView setHidden:NO];
        [self.tableView setHidden:YES];
        
        isShowMap = YES;
        
    }else{
        [self setGroupBuyNavigationRightButton:@"地图" action:@selector(clickRightButton:)];
        self.navigationItem.title = @"地址列表";
        [self.mapView setHidden:YES];
        [self.tableView setHidden:NO];
        
        isShowMap = NO;
    }
    
//    [self enableGroupBuySettings];
}

- (void) clickRightButton:(id)sender
{
    if (isShowMap) {
        [self setGroupBuyNavigationRightButton:@"地图" action:@selector(clickRightButton:)];
        self.navigationItem.title = @"地址列表";
        [self setGroupBuyNavigationTitle:self.navigationItem.title];
        [tableView setHidden:NO];
        [mapView setHidden:YES];
        isShowMap = NO;
    }
    else {
        [self setGroupBuyNavigationRightButton:@"列表" action:@selector(clickRightButton:)];
        self.navigationItem.title = @"地图";
        [self setGroupBuyNavigationTitle:self.navigationItem.title];
        [tableView setHidden:YES];
        [mapView setHidden:NO];
        isShowMap = YES;
    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma -mark table view delegate;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74/2;    // the height of background image
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.addressList count];
    }
    return 0;
}

#define FIRST_CELL_IMAGE    @"tu_56.png"
#define MIDDLE_CELL_IMAGE   @"tu_69.png"
#define LAST_CELL_IMAGE     @"tu_86.png"
#define SINGLE_CELL_IMAGE   @"tu_60.png"

- (UITableViewCell *)tableView:(UITableView *)tbView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tbView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];	
    }    
    cell.textLabel.text = [self.addressList objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    cell.textLabel.textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:163/255.0 green:155/255.0 blue:143/255.0 alpha:1.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    int count = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    [cell setCellBackgroundForRow:indexPath.row rowCount:count singleCellImage:SINGLE_CELL_IMAGE firstCellImage:FIRST_CELL_IMAGE  middleCellImage:MIDDLE_CELL_IMAGE lastCellImage:LAST_CELL_IMAGE cellWidth:300];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

#pragma -mark mkmapview delegate

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = DEFAULT_PIN_ID; 
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID]; 
    if ( pinView == nil ) 
        pinView = [[[MKPinAnnotationView alloc] 
                                      initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease]; 
    pinView.pinColor = MKPinAnnotationColorRed; 
    pinView.canShowCallout = YES; 
    pinView.selected = YES;
    return pinView; 
}


#pragma -mark action
- (void)onclickBack:(id)sender
{
    int count = [self.navigationController.viewControllers count];
    if (count >= 2){
        UIViewController* vc = [self.navigationController.viewControllers objectAtIndex:count-2];
        vc.hidesBottomBarWhenPushed = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#define CITY_TABLE_VIEW_FRAME   CGRectMake(8, 8, 304, 480-44-20-8-55-5)

- (void)enableGroupBuySettings
{
    self.useForGroupBuy = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setBackgroundImageName:@"background.png"];
    [self setTableViewFrame:CITY_TABLE_VIEW_FRAME];
    [self setGroupBuyNavigationTitle:self.navigationItem.title];
    [self setGroupBuyNavigationBackButton];
}

@end


