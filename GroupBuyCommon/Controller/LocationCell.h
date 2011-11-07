//
//  LocationSlider.h
//  groupbuy
//
//  Created by qqn_pipi on 11-9-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PPTableViewCell.h"
#import "PPMKMapViewController.h"

#define DEGREE_NOT_SET 0
#define MIN_RADIUS 200
@protocol LocationCellDelegate <NSObject>

-(void) didSwitchOn;

@end

//@protocol LocationCellDelegate <NSObject>
//
//- (void) didSelectLocation: (CLLocationCoordinate2D)coordinate radius:(CGFloat)radius;
//
//@end

@class PPMKMapViewController;

@interface LocationCell : PPTableViewCell <PPMKMapViewControllerDelegate>{
    
    UILabel *locationLabel;
    UILabel *areaLabel;
    CLLocationCoordinate2D coordinate;
    CLLocationDistance radius;
//    PPMKMapViewController *mapViewController;
    id<LocationCellDelegate> locationCellDelegate;
    
}
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *areaLabel;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationDistance radius;
//@property (nonatomic, retain) PPMKMapViewController *mapViewController;
@property (nonatomic, assign) id<LocationCellDelegate>locationCellDelegate;


+ (LocationCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)r;
- (void)setLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude radius:(NSNumber *)r;

-(void)didChangeLocation:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius;

- (NSNumber *)getLatitude;
- (NSNumber *)getLongtitude;
- (NSNumber *)getRadius;
@end
