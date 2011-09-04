//
//  CommentTableViewCell.h
//  groupbuy
//
//  Created by  on 11-9-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell {
    UILabel *contentLabel;
    UILabel *nickNameLabel;
    UILabel *createDateLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *contentLabel;
@property (nonatomic, retain) IBOutlet UILabel *nickNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *createDateLabel;

+ (CommentTableViewCell *)createCell;
+ (NSString *)getCellIdentifier;
- (void)setCellInfoWithContent:(NSString *)content nickName:(NSString *)nickName createDate:(NSDate *)createDate;

@end
