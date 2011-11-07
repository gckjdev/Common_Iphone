//
//  LocationSlider.m
//  groupbuy
//
//  Created by qqn_pipi on 11-9-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocationCell.h"
#import "PPMKMapViewController.h"
#import "LocationService.h"
@implementation LocationCell
@synthesize locationLabel;
@synthesize areaLabel;
@synthesize coordinate;
@synthesize radius;
//@synthesize mapViewController;
@synthesize locationCellDelegate;

- (void)dealloc
{
    [locationLabel release];
    [areaLabel release];
//    [mapViewController release];
    [super dealloc];
}

// just replace PPTableViewCell by the new Cell Class Name
+ (LocationCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LocationCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <LocationCell> but cannot find cell object from Nib");
        return nil;
    }
    LocationCell *cell = (LocationCell *)[topLevelObjects objectAtIndex:0];
////    cell.mapViewController = [[PPMKMapViewController alloc] init];
    cell.coordinate = CLLocationCoordinate2DMake(DEGREE_NOT_SET, DEGREE_NOT_SET);
    
//    cell.mapViewController.mapViewdelegate = cell;
    cell.areaLabel.text = nil;
    cell.locationLabel.text = nil;
    cell.delegate = delegate;

    
    return cell;
}


+ (NSString*)getCellIdentifier
{
    return @"LocationCell";
}

+ (CGFloat)getCellHeight
{
    return 77;
}

- (void)setLabelText:(CLLocationDistance)r
{
    NSString *str = @"";
    if (r < 1000 && r > 0 ) {
        str = [NSString stringWithFormat:@"附近 %d 米",(int)r];
    }else if(r >=1000 ){
        str = [NSString stringWithFormat:@"附近 %.1f 公里",r/1000];
    }
    else{
        str = @"不限";
    }
    self.areaLabel.text = str;
}

- (void)setCoordinate:(CLLocationCoordinate2D)c radius:(CLLocationDistance)r
{
    self.coordinate = c;
    self.radius = r;
    [self setLabelText:r];
}

- (void)setLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude radius:(NSNumber *)r
{
    CLLocationCoordinate2D coorinate;
    CLLocationDistance distance;
    if (latitude == nil || longitude == nil || r == nil || [r intValue] < MIN_RADIUS) {
        coorinate = CLLocationCoordinate2DMake(DEGREE_NOT_SET, DEGREE_NOT_SET);
        distance = -1;
    }else{
        coorinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        distance = [r doubleValue];
    }
    [self setCoordinate:coorinate radius:distance];
}

-(void)didChangeLocation:(CLLocationCoordinate2D)c radius:(CLLocationDistance)r
{
    if (r > 0.0f){
        [self setCoordinate:c radius:r];
    }
    else{
        [self setLatitude:nil longitude:nil radius:nil];
    }
}




- (NSNumber *)getLatitude
{
    if ((int)self.coordinate.latitude == DEGREE_NOT_SET) {
        return nil;
    }
    NSNumber * lat =[NSNumber numberWithDouble:self.coordinate.latitude];
    return lat;
}
- (NSNumber *)getLongtitude
{
    if ((int)self.coordinate.longitude== DEGREE_NOT_SET) {
        return nil;
    }
    NSNumber *longtitude = [NSNumber numberWithDouble:self.coordinate.longitude];
    return longtitude;
}
- (NSNumber *)getRadius
{
    NSNumber *r = nil;
    if (self.radius >= MIN_RADIUS) {
        r = [NSNumber numberWithDouble:self.radius];
    }
    return r;
}


@end
