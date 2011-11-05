//
//  CommentTableViewCell.m
//  groupbuy
//
//  Created by  on 11-9-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "TimeUtils.h"
#import "LocaleUtils.h"

@implementation CommentTableViewCell

@synthesize contentLabel;
@synthesize nickNameLabel;
@synthesize createDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString*)getDateDisplayText:(NSDate*)date
{
    if (date == nil)
        return @"";
    
    int second = abs([date timeIntervalSinceNow]);
    
    if (second < 60){
        return [NSString stringWithFormat:NSLS(@"kDateBySecond"), second];
    }
    else if (second < 60*60){
        return [NSString stringWithFormat:NSLS(@"kDateByMinute"), second/(60)];        
    }
    else if (second < 60*60*24){
        return [NSString stringWithFormat:NSLS(@"kDateByHour"), second/(60*60)];                
    }
    else if (second < 60*60*24*3){
        return [NSString stringWithFormat:NSLS(@"kDateByDay"), second/(60*60*24)];                
    }
    else{
        return dateToStringByFormat(date, @"yyyy-MM-dd");                        
    }    
}

+ (NSString *)getCellIdentifier
{
    return @"CommentTableViewCell";
}

+ (CommentTableViewCell *)createCell
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"<createCommentTableViewCell> but cannot find cell object");
        return nil;
    }
    
    return (CommentTableViewCell *)[topLevelObjects objectAtIndex:0];
}

- (void)setCellInfoWithContent:(NSString *)content nickName:(NSString *)nickName createDate:(NSDate *)createDate
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nickNameLabel.text = nickName;
    self.createDateLabel.text = [self getDateDisplayText:createDate];
    
    CGRect fra = self.contentLabel.frame;
    CGSize size = CGSizeMake(fra.size.width, 10000);
    size = [content sizeWithFont:self.contentLabel.font constrainedToSize:size];
    CGFloat d = fra.size.height - size.height;
    fra = CGRectMake(fra.origin.x, fra.origin.y, fra.size.width, fra.size.height - d);
    self.contentLabel.frame = fra;
    self.contentLabel.text = content;
    
    fra = self.frame;
    fra = CGRectMake(fra.origin.x, fra.origin.y, fra.size.width, fra.size.height - d);
    self.frame = fra;
    
}

@end
