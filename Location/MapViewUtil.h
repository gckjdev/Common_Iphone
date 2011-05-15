//
//  MapViewUtil.h
//  ExchangeLocation
//
//  Created by qqn_pipi on 10-9-12.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
				  zoomLevel:(NSUInteger)zoomLevel
				   animated:(BOOL)animated;

- (int) getZoomLevel;

@end 

