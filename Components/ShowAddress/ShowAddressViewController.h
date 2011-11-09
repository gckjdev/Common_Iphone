//
//  ShowAddressViewController.h
//  AddressList
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PPTableViewController.h"

#define LATITUDEDELTA 0.1f
#define LONGITUDEDELTA 0.1f
#define DEFAULT_PIN_ID @"com.orange.pinid"

@interface ShowAddressViewController : PPTableViewController <MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet MKMapView *mapView;
    UITableView *tableView;
    NSArray *addressList;
    NSArray *locationArray;
    
    BOOL isShowMap;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *locationArray;
@property (nonatomic, retain) NSArray *addressList;
@property (nonatomic, assign) BOOL useForGroupBuy;

- (id)initWithLocationArray:(NSArray *)aLocationArray addressList: (NSArray *)aAddressList;
- (void)onclickBack:(id)sender;
- (void)enableGroupBuySettings;


@end
