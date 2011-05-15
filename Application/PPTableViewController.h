//
//  PPTableViewController.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-1.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPViewController.h"
#import "GroupDataAZ.h"
#import "ArrayOfCharacters.h"

@interface PPTableViewController : PPViewController <UITableViewDelegate, UITableViewDataSource> {

	NSArray				 *dataList;
	IBOutlet UITableView *dataTableView;
	GroupDataAZ			 *groupData;

	UIImageView		*singleCellImage;
	UIImageView		*firstCellImage;
	UIImageView		*middleCellImage;
	UIImageView		*lastCellImage;
	UIImageView		*cellImage;
	UIImageView		*sectionImage;
	UIImageView		*footerImage;
	UILabel			*sectionLabel;
	
	int				selectRow;
	int				selectSection;
	int				oldSelectRow;
	int				oldSelectSection;

	
	CGFloat			singleImageHeight;
	CGFloat			firstImageHeight;
	CGFloat			middleImageHeight;
	CGFloat			lastImageHeight;
	CGFloat			cellImageHeight;
	CGFloat			sectionImageHeight;
	CGFloat			footerImageHeight;
	
	UIColor			*cellTextLabelColor;
	UIView			*accessoryView;
	
	// the following two attributes are useless
	BOOL			enableCustomIndexView;
//	CustomIndexView	*customIndexView;
	
}

@property (nonatomic, retain) NSArray			*dataList;
@property (nonatomic, retain) IBOutlet UITableView		*dataTableView;
@property (nonatomic, retain) UIImageView		*singleCellImage;
@property (nonatomic, retain) UIImageView		*firstCellImage;
@property (nonatomic, retain) UIImageView		*middleCellImage;
@property (nonatomic, retain) UIImageView		*lastCellImage;
@property (nonatomic, retain) UIImageView		*cellImage;
@property (nonatomic, retain) UIImageView		*sectionImage;
@property (nonatomic, retain) UIImageView		*footerImage;

@property (nonatomic, retain) UILabel			*sectionLabel;
@property (nonatomic, retain) GroupDataAZ		*groupData;
@property (nonatomic, retain) UIColor			*cellTextLabelColor;
@property (nonatomic, retain) UIView			*accessoryView;
@property (nonatomic, assign) BOOL				enableCustomIndexView;
//@property (nonatomic, retain) CustomIndexView	*customIndexView;

- (void)setSingleCellImageByName:(NSString*)imageName;
- (void)setFirstCellImageByName:(NSString*)imageName;
- (void)setMiddleCellImageByName:(NSString*)imageName;
- (void)setLastCellImageByName:(NSString*)imageName;
- (void)setCellImageByName:(NSString*)imageName;
- (void)setSectionImageByName:(NSString*)imageName;
- (void)setFooterImageByName:(NSString*)imageName;

- (void)setCellBackground:(UITableViewCell*)cell row:(int)row count:(int)count;
- (CGFloat)getRowHeight:(int)row totalRow:(int)totalRow;
- (UIView*)getSectionView:(UITableView*)tableView section:(int)section;
- (UIView*)getFooterView:(UITableView*)tableView section:(int)section;

- (BOOL)isCellSelected:(NSIndexPath*)indexPath;
- (void)resetSelectRowAndSection;
- (void)updateSelectSectionAndRow:(NSIndexPath*)indexPath;
- (void)reloadForSelectSectionAndRow:(NSIndexPath*)indexPath;

@end
