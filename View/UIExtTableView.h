//
//  UIExtTableView.h
//  Test
//
//  Created by Peng Lingzhe on 5/31/10.
//  Copyright 2010 Ericsson. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol UIExtTableViewDelegate <UITableViewDelegate, UITableViewDataSource, NSObject>

- (CGFloat)tableView:(UITableView *)tableView heightForExtraRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForExtraRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectExtraRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forExtraRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface UIExtTableView : UIView <UITableViewDelegate, UITableViewDataSource> {

	// internal GUI objects
	UITableView				*tableView;

	// external parameters
	int						minRowNumber;			// the minimum extra row number of table view, set by external	
	int						maxRowNumber;			// the maximum extra row number of table view, set by external
	id<UIExtTableViewDelegate>	delegate;
	
	int						numOfRow;
}

@property (nonatomic)		  int				minRowNumber;
@property (nonatomic)		  int				maxRowNumber;
@property (nonatomic, retain) UITableView		*tableView;
@property (nonatomic, assign) id<UIExtTableViewDelegate>	delegate;

- (BOOL)isFirstRow:(NSIndexPath*)indexPath;
- (BOOL)isLastRow:(NSIndexPath*)indexPath;
- (BOOL)isMiddelRow:(NSIndexPath*)indexPath;

- (void)reloadData;

@end
