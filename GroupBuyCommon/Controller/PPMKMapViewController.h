//
//  PPMKMapViewController.h
//  AboutLocation
//
//  Created by qqn_pipi on 11-9-10.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PPViewController.h"

#define LATITUDEDELTA 0.2f
#define LONGITUDEDELTA 0.2f
#define DEFAULT_PIN_ID @"com.orange.pinid"
#define RADIUS 5000
@protocol PPMKMapViewControllerDelegate <NSObject>

@required
-(void)didChangeLocation:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius;

@end


@interface PPMKMapViewController : PPViewController<MKMapViewDelegate> {

    UISlider *radiusSlider;
    UILabel *areaLabel;
    CLLocationCoordinate2D currentCoordinate;
    CLLocationDistance radius;
    MKMapView *mapView;
    MKCircle *locationCircle;
    id<PPMKMapViewControllerDelegate>mapViewdelegate;
}

@property (nonatomic, retain) IBOutlet UISlider *radiusSlider;
@property (nonatomic, retain) IBOutlet UILabel *areaLabel;
@property (nonatomic, readwrite) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, readwrite) CLLocationDistance radius;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) id<PPMKMapViewControllerDelegate>mapViewdelegate;
@property (nonatomic, retain) MKCircle *locationCircle;
- (IBAction)radiusChange:(id)sender;

- (void)resetMap;
- (id)init;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius;
- (id)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius;

//- (void)resetCircle;

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)r;

- (void)setAreaLabelWithRadius:(CLLocationDistance)r;
- (void)setSlider:(CLLocationDistance)r;
- (void)setCircle:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)r;
- (void)setCenter:(CLLocationCoordinate2D)center;
- (void)setMark:(CLLocationCoordinate2D)mark;

@end


