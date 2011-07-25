//
//  ProductTextCell.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductTextCell.h"
#import "Product.h"
#import "LocationService.h"

@implementation ProductTextCell

@synthesize productDescLabel;
@synthesize valueLabel;
@synthesize priceLabel;
@synthesize rebateLabel;
@synthesize leftTimeLabel;
@synthesize distanceLabel;
@synthesize boughtLabel;

// just replace PPTableViewCell by the new Cell Class Name
+ (ProductTextCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProductTextCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ProductTextCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ProductTextCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ProductTextCell*)[topLevelObjects objectAtIndex:0];
}

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

+ (NSString*)getCellIdentifier
{
    return @"ProductTextCell";
}

+ (CGFloat)getCellHeight
{
    return 114.0f;
}

- (NSString*)getTimeInfo:(int)seconds
{
    if (seconds <=0 ){
        return @"已结束";
    }
    else if (seconds < 60){
        return [NSString stringWithFormat:@"还有%d秒", seconds];
    }
    else if (seconds < 60*60){
        return [NSString stringWithFormat:@"还有%d分钟", seconds/60];        
    }
    else if (seconds < 60*60*24){
        return [NSString stringWithFormat:@"还有%d小时", seconds/(60*60)];        
    }
    else{
        return [NSString stringWithFormat:@"还有%d天", seconds/(60*60*24)];                
    }
}

- (NSString *)calculateDistance:(Product *)product
{
    double pLatitude = [[product latitude] doubleValue];
    double pLongitude = [[product longitude] doubleValue];
    LocationService *locationService = GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];
    
    NSLog(@"current:(lat=%f,long=%f)",location.coordinate.latitude,location.coordinate.longitude);
    pLatitude = location.coordinate.latitude + (rand()%30)/1000.1;
    pLongitude = location.coordinate.longitude + (rand()%30)/1000.1;
    
    CLLocation *pLocation = [[CLLocation alloc]initWithLatitude:pLatitude longitude:pLongitude];
    CLLocationDistance distance = [location distanceFromLocation:pLocation];
    [pLocation release];
    NSString *distanceString = nil;
    if(distance < 1000){
        int d = (int) distance;
        distanceString = [NSString stringWithFormat:@"%d米",d];
    }else {
        float d = distance/1000;
        distanceString = [NSString stringWithFormat:@"%0.1f公里",d];
    }
    return distanceString;
}

- (void)setCellInfoWithProduct:(Product*)product indexPath:(NSIndexPath*)indexPath
{
    int leftSeconds = [[product endDate] timeIntervalSinceNow];
    NSString* timeInfo = [self getTimeInfo:leftSeconds];
    
    self.productDescLabel.text = [NSString stringWithFormat:@"%@ - %@", [product siteName], [product title]];
    self.valueLabel.text = [NSString stringWithFormat:@"原价:%.2f元", [[product value] doubleValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"团购价:%.2f元", [[product price] doubleValue]];
    self.leftTimeLabel.text = [NSString stringWithFormat:@"时间:%@", timeInfo];
    
    NSString *distance = [self calculateDistance:product];

    self.distanceLabel.text = [NSString stringWithFormat:@"距离:%@",distance];
    
    self.boughtLabel.text = [NSString stringWithFormat:@"已购买:%d", [[product bought] intValue] ];    
    self.rebateLabel.text = [NSString stringWithFormat:@"折扣:%.1f折", [[product rebate] doubleValue] ]; //[[product.rebate] doubleValue]];
}

- (void)dealloc {
    [productDescLabel release];
    [valueLabel release];
    [priceLabel release];
    [rebateLabel release];
    [leftTimeLabel release];
    [distanceLabel release];
    [boughtLabel release];
    [super dealloc];
}

@end

