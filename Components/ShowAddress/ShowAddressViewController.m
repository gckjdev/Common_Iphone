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

@implementation ShowAddressViewController
@synthesize mapView;
@synthesize tableView;
@synthesize locationArray;
@synthesize addressList;

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onclickBack:)];
    
    
    
    BOOL locationFlag = (locationArray && [locationArray count] > 0) ? YES : NO;
    BOOL addressFlag = (addressList && [addressList count] > 0) ? YES : NO;
    
    
    if (!locationFlag && !addressFlag) {
        return;
    }
    
    if ([locationArray count] == 0)
        return;
    
    if (locationFlag) {
        //[self.tableView setHidden:YES];
        self.mapView.delegate = self;
        [mapView setShowsUserLocation:YES];
        MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
        theRegion.center = [[locationArray objectAtIndex:0] coordinate];
        [self.mapView setZoomEnabled:YES]; 
        [self.mapView setScrollEnabled:YES]; 
        theRegion.span.longitudeDelta = LONGITUDEDELTA; 
        theRegion.span.latitudeDelta = LATITUDEDELTA; 
    
//        [self.mapView setRegion:theRegion animated:NO];
        
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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
        self.navigationItem.title = @"地图";
        [self.mapView setHidden:NO];
        [self.tableView setHidden:YES];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
        self.navigationItem.title = @"地址列表";
        [self.mapView setHidden:YES];
        [self.tableView setHidden:NO];
    }
}

- (void) clickRightButton:(id)sender
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"列表"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
        self.navigationItem.title = @"地址列表";
        [tableView setHidden:NO];
        [mapView setHidden:YES];
    }else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"地图"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
            self.navigationItem.title = @"地图";
            [tableView setHidden:YES];
            [mapView setHidden:NO];
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
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.addressList count];
    }
    return 0;
}

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
    return cell;
}


#pragma -mark mkmapview delegate

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = DEFAULT_PIN_ID; 
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID]; 
    if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc] 
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

@end


