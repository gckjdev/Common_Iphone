//
//  PPTableViewCell.m
//  Dipan
//
//  Created by qqn_pipi on 11-6-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PPTableViewCell.h"


@implementation PPTableViewCell

@synthesize indexPath;
@synthesize delegate;
@synthesize tableViewController;

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

- (void)dealloc
{
    [delegate release];
    [indexPath release];
    [tableViewController release];
    [super dealloc];
}

// the following code is just for copy

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		   
}

- (void)awakeFromNib{
    [self setCellStyle];
}

// just replace PPTableViewCell by the new Cell Class Name
+ (PPTableViewCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PPTableViewCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <PPTableViewCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((PPTableViewCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (PPTableViewCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"PPTableViewCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

@end
