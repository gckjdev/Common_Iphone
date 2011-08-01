//
//  TelPickerViewController.h
//  TelPicker
//
//  Created by qqn_pipi on 11-8-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelPickerViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSArray *telArray;
    UITableView *telPickerTable;
    NSString *selectedTelNumber;
}

@property (nonatomic, retain) NSArray *telArray;
@property (nonatomic, retain) IBOutlet UITableView *telPickerTable;
@property (nonatomic, retain) NSString *selectedTelNumber;

- (id)initWithTelArray:(NSArray *)telArr;
- (void)callTelNumber:(NSString *)number;
- (void)onclickBack:(id)sender;
@end
