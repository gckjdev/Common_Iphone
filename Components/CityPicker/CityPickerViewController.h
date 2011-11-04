//
//  CityPickerViewController.h
//  CityPicker
//
//  Created by qqn_pipi on 11-7-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


//#import "PPViewController.h"

#import <UIKit/UIKit.h>
#import "CityPickerManager.h"
#import "PPTableViewController.h"

@protocol CityPickerDelegate <NSObject>

-(void) dealWithPickedCity:(NSString *)city;

@end


@interface CityPickerViewController : PPTableViewController <UITableViewDelegate,UITableViewDataSource>{
    UITableView *cityTableView;
    CityPickerManager *cityPickerManager;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    NSString *defaultCity;
    NSString *selectedCity;
    id<CityPickerDelegate>delegate;
}
@property (nonatomic, retain) IBOutlet UITableView *cityTableView;
@property (nonatomic, retain) CityPickerManager *cityPickerManager;
@property (nonatomic, retain) UIBarButtonItem *leftButton;
@property (nonatomic, retain) UIBarButtonItem *rightButton;
@property (nonatomic, retain) NSString *selectedCity;
@property (nonatomic, retain) NSString *defaultCity;
@property (nonatomic, retain) id<CityPickerDelegate>delegate;
@property (nonatomic, assign) BOOL useForGroupBuy;

- (id)initWithCityName:(NSString *)cityName hasLeftButton:(BOOL) hasLeftButton;
- (NSIndexPath *)indexPathForCity:(NSString *)cityName;
- (void)onclickBack:(id)sender;
- (void)onclickConfirm:(id)sender;

- (void)enableGroupBuySettings;

@end
