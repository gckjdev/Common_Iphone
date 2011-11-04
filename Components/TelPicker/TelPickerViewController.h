//
//  TelPickerViewController.h
//  TelPicker
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface TelPickerViewController : PPTableViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSArray *telArray;
    UITableView *telPickerTable;
    NSString *selectedTelNumber;
}

@property (nonatomic, retain) NSArray *telArray;
@property (nonatomic, retain) IBOutlet UITableView *telPickerTable;
@property (nonatomic, retain) NSString *selectedTelNumber;
@property (nonatomic, assign) BOOL useForGroupBuy;

- (id)initWithTelArray:(NSArray *)telArr;
- (void)callTelNumber:(NSString *)number;
- (void)onclickBack:(id)sender;
- (void)enableGroupBuySettings;

@end
