//
//  PPMKMapViewController.m
//  AboutLocation
//
//  Created by qqn_pipi on 11-9-10.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import "PPMKMapViewController.h"
#import "LocationService.h"
#import "MapViewUtil.h"

@implementation PPMKMapViewController
@synthesize radiusSlider;
@synthesize areaLabel;
@synthesize radius;
@synthesize mapView;
@synthesize currentCoordinate;
@synthesize mapViewdelegate;
@synthesize locationCircle;


- (NSString *)getAreaDesc:(CLLocationDistance)r
{
    self.areaLabel.textColor = [UIColor redColor];
    NSString *str = nil;
    if (r > 1000) {
        str = [NSString stringWithFormat:@"半径 %.1f 公里",r/1000];
    }else if (r > 0){
        str = [NSString stringWithFormat:@"半径 %d 米",(NSInteger)r];
    }
    else{
        str = @"不限";
    }
    return str;
}

- (IBAction)radiusChange:(id)sender {
    CLLocationDistance r = radiusSlider.value * 1000;
    self.radius = r;
    [self setAreaLabelWithRadius:r];
    [self setCircle:self.currentCoordinate radius:r];
    
}

- (void)resetMap{
    LocationService *service = GlobalGetLocationService();
    [self setCoordinate:[[service currentLocation]coordinate] radius:0];

}

- (void)setDefault{
    LocationService *service = GlobalGetLocationService();
    self.currentCoordinate = [[service currentLocation] coordinate];
    self.radius = 0;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setDefault];
    }
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c radius:(CLLocationDistance)r
{
    self = [super init];
    if (self) {
        self.currentCoordinate = c;
        self.radius = r;
    }
    return self;
}


- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)r
{
    self = [super init];
    if (self) {
         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.radius = r;
        self.currentCoordinate = coordinate;
 //       [self setCoordinate:coordinate radius:radius];    
    }
    return self;
}

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

    self.mapView.delegate=self; 
    [self.mapView setZoomEnabled:YES]; 
    [self.mapView setScrollEnabled:YES]; 
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
    theRegion.center = self.currentCoordinate;
    theRegion.span.longitudeDelta = LONGITUDEDELTA; 
    theRegion.span.latitudeDelta = LATITUDEDELTA; 
    self.mapView.showsUserLocation = YES;
    [self.mapView setRegion:theRegion animated:YES];  
    
    
    [self setCoordinate:self.currentCoordinate radius:self.radius];
    
    [mapView setCenterCoordinate:self.currentCoordinate zoomLevel:12 animated:NO];
    
    self.navigationItem.title = @"选择位置";
    [self setNavigationLeftButton:@"返回" action:@selector(clickBack:)];
    [self setNavigationRightButton:@"保存" action:@selector(clickSave:)];
    
//    [self.mapView set

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setCoordinate:self.currentCoordinate radius:self.radius];
    
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
    [self setRadiusSlider:nil];
    [self setAreaLabel:nil];
    [self setMapView:nil];
    [self setMapViewdelegate:nil];
    [self setLocationCircle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [mapViewdelegate release];
    [radiusSlider release];
    [areaLabel release];
    [mapView release];
    [locationCircle release];
    [super dealloc];
}

#pragma action
-(void) clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void ) clickSave:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.mapViewdelegate respondsToSelector:@selector(didChangeLocation:radius:)]) {
        [self.mapViewdelegate didChangeLocation:self.currentCoordinate radius:self.radius];
    }
}


#pragma mkmapview delegate.

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState{
    if (newState == MKAnnotationViewDragStateEnding) {
        self.currentCoordinate = view.annotation.coordinate;
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = DEFAULT_PIN_ID; 
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID]; 
    if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc] 
                                      initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease]; 
    pinView.pinColor = MKPinAnnotationColorRed; 
    pinView.canShowCallout = YES; 
    pinView.draggable = YES;
    pinView.selected = YES;
    annotation.coordinate = self.currentCoordinate;
    [self.mapView.userLocation setTitle:@"所选位置"];
    NSString *subTitle = [NSString stringWithFormat:@"(%.3f,%.3f)",currentCoordinate.latitude,currentCoordinate.longitude];
    [self.mapView.userLocation setSubtitle:subTitle];
    return pinView; 
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView* circleView = [[[MKCircleView alloc] initWithOverlay:overlay] autorelease];
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        circleView.lineWidth = 3.0;
        return circleView;
    }
    
    return nil;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self setCircle:self.currentCoordinate radius:self.radius];
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)r
{
    self.radius = r;
    [self setMark:coordinate];
    [self setAreaLabelWithRadius:r];
    [self setCircle:coordinate radius:r];
    [self setSlider:r];
    [self setCenter:coordinate];
    
}


- (void)setAreaLabelWithRadius:(CLLocationDistance)r
{
    self.areaLabel.text = [self getAreaDesc:r];
}

- (void)setSlider:(CLLocationDistance)r
{
    self.radiusSlider.value = r/1000.0;
}

- (void)setCircle:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)r
{
    self.locationCircle = [MKCircle circleWithCenterCoordinate:currentCoordinate radius:r];
    while (self.mapView.overlays != nil && [self.mapView.overlays count] > 0) {
        [self.mapView removeOverlays:self.mapView.overlays];
    }
    [self.mapView addOverlay:locationCircle];
}

- (void)setCenter:(CLLocationCoordinate2D)center
{
    [self.mapView setCenterCoordinate:center];
}

- (void)setMark:(CLLocationCoordinate2D)mark
{
    self.currentCoordinate = mark;
}



@end
