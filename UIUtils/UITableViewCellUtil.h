//
//  UITableViewCellUtil.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-10.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICheckAndDetailView.h"

@interface UITableViewCell (UITableViewCellUtil) 

- (void)setBlueBlackBackground:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)addCheckAndDetailView:(id)delegate;
- (UICheckAndDetailView*)getCheckAndDetailView;
- (void)setBackgroundImage:(UIImage*)image;
- (void)setBackgroundImageByName:(NSString*)imageName;

- (void)setBackgroundImageByName:(NSString*)imageName alpha:(float)alpha;
- (void)setBackgroundImage:(UIImage*)image alpha:(float)alpha;
- (void)setBackgroundImageByView:(UIImageView*)imageView;

- (UIToolbar*)addToolbar:(NSArray*)barButtons autoAddSpaceButton:(BOOL)autoAddSpaceButton;
- (void)removeToolbar;

- (void)setCellBackgroundForRow:(int)row 
                       rowCount:(int)count 
                singleCellImage:(NSString*)singleCellImageName
                 firstCellImage:(NSString*)firstCellImageName
                middleCellImage:(NSString*)middleCellImageName
                  lastCellImage:(NSString*)lastCellImageName
                      cellWidth:(int)cellWidth;

@end
