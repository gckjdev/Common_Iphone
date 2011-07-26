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
#import "TimeUtils.h"
#import "GroupBuyNetworkConstants.h"

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

- (NSString *)calculateDistance:(double)pLatitude longitude:(double)pLongitude
{
    LocationService *locationService = GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];
    
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

- (void)setCellInfoWithProductInfo:(NSDate*)endDate
                          siteName:(NSString*)siteName
                             title:(NSString*)title
                             value:(NSNumber*)value
                             price:(NSNumber*)price
                            bought:(NSNumber*)bought
                            rebate:(NSNumber*)rebate
                         longitude:(NSNumber*)longitude
                          latitude:(NSNumber*)latitude
{
    int leftSeconds = [endDate timeIntervalSinceNow];
    NSString* timeInfo = [self getTimeInfo:leftSeconds];
    
    self.productDescLabel.text = [NSString stringWithFormat:@"%@ - %@", siteName, title];
    self.valueLabel.text = [NSString stringWithFormat:@"原价:%@元", [value description]];
    self.priceLabel.text = [NSString stringWithFormat:@"团购价:%@元", [price description]];
    self.leftTimeLabel.text = [NSString stringWithFormat:@"时间:%@", timeInfo];
    
    if (longitude && latitude){
        NSString *distance = [self calculateDistance:[latitude doubleValue] longitude:[longitude doubleValue]];    
        self.distanceLabel.text = [NSString stringWithFormat:@"距离:%@",distance];
    }
    else{
        self.distanceLabel.text = @"";        
    }
    
    self.boughtLabel.text = [NSString stringWithFormat:@"已购买:%@", [bought description]];    
    self.rebateLabel.text = [NSString stringWithFormat:@"折扣:%@折", [rebate description]]; 

}

- (void)setCellInfoWithProductDictionary:(NSDictionary*)product indexPath:(NSIndexPath*)indexPath
{
    NSDate* endDate = dateFromStringByFormat([product objectForKey:PARA_END_DATE], DEFAULT_DATE_FORMAT);
    NSString* siteName = [product objectForKey:PARA_SITE_NAME];
    NSString* title = [product objectForKey:PARA_TITLE];
    NSNumber* value = [product objectForKey:PARA_VALUE];
    NSNumber* price = [product objectForKey:PARA_PRICE];
    NSNumber* bought = [product objectForKey:PARA_BOUGHT];
    NSNumber* rebate = [product objectForKey:PARA_REBATE];    
    NSNumber* longitude = [product objectForKey:PARA_LONGTITUDE];    
    NSNumber* latitude = [product objectForKey:PARA_LATITUDE];    
    
    [self setCellInfoWithProductInfo:endDate siteName:siteName title:title value:value price:price bought:bought rebate:rebate longitude:longitude latitude:latitude];
}


- (void)setCellInfoWithProduct:(Product*)product indexPath:(NSIndexPath*)indexPath
{
    [self setCellInfoWithProductInfo:product.endDate siteName:product.siteName title:product.title value:product.value price:product.price bought:product.bought rebate:product.rebate longitude:product.longitude latitude:product.latitude];
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

