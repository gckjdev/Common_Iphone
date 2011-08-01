//
//  AnnotationPin.m
//  AboutLocation
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AnnotationPin.h"


@implementation AnnotationPin

@synthesize coordinate,title,subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle
{   
    self = [super init];
    if (self) {
        self.coordinate = aCoordinate;
        self.title = aTitle;
        self.subtitle = aSubtitle;
    }
    return self;
    
}

- (void)dealloc{
    [title release];
    [super dealloc];
}

@end
