//
//  MoreTableViewCell.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "LocaleUtils.h"

@implementation MoreTableViewCell
@synthesize loadingView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)awakeFromNib{
    self.textLabel.text = NSLS(@"More...");
    self.textLabel.textAlignment = UITextAlignmentCenter;
}

- (void)dealloc
{
    [loadingView release];
    [super dealloc];
}

+ (MoreTableViewCell*)createCell:(UITableView*)tableView
{
    MoreTableViewCell *cell = (MoreTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MoreTableViewCell"];
    
	if (cell == nil) {
    
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" 
                                                                 owner:self 
                                                               options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
        if (topLevelObjects == nil || [topLevelObjects count] <= 0){
            NSLog(@"<createMoreTableViewCell> but cannot find cell object");
            return nil;
        }
        
        return (MoreTableViewCell*)[topLevelObjects objectAtIndex:0];
    }
    
    return cell;
 
}

+ (float)getRowHeight
{
    return 45.0f;
}

@end
