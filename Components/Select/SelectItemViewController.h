//
//  SelectItemViewController.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-4.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

#define kUnknownSelectRow (-1)

@protocol SelectItemViewControllerDelegate<NSObject>

@optional

- (BOOL)shouldContinueAfterRowSelect:(int)row;

@end

@interface SelectItemViewController : PPTableViewController <SelectItemViewControllerDelegate> {

	int		inputSelectRow;
	id		delegate;
	int		itemSelectRow;
}

@property (nonatomic, assign) int inputSelectRow;
@property (nonatomic, assign) id  delegate;

@end

/* Example Code

 SelectItemViewController* vc = [[SelectItemViewController alloc] init];
 
 [vc setDataList:[NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil]];
 [vc setInputSelectRow:2];	
 vc.delegate = self;

 
 // test code, to be removed
 - (BOOL)shouldContinueAfterRowSelect:(int)row
 {
 NSLog(@"selected row is %d", row);
 return NO;
 }
 
*/