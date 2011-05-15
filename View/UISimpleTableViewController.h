//
//  UISimpleTableViewController.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-9.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavTableViewController.h"
#import "ActionSelector.h"

@interface UISimpleTableViewController : UINavTableViewController {

	// ID of selected item
	NSArray* idArray;
	
	// title for table display
	NSArray* titleArray;

	NSObject* selectedId;
	
	NSIndexPath* selectedIndexPath;
	
	ActionSelector* action;
	
}

@property (nonatomic, retain) NSArray *idArray;
@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSObject *selectedId;
@property (nonatomic, retain) NSIndexPath* selectedIndexPath;
@property (nonatomic, retain) ActionSelector* action;

- (id)initWithStyle:(UITableViewStyle)style idArray:(NSArray *)aIdArray titleArray:(NSArray *)aTitleArray selectedId:(NSObject *)aSelectedId;

- (void)setDoneTarget:(id)target selector:(SEL)selector;

- (void)clickCancel:(id)sender;

@end
