//
//  DownloadItemCell.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadItemCell.h"

@implementation DownloadItemCell

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		   
}

- (void)awakeFromNib{
    [self setCellStyle];
}

// just replace ProductDetailCell by the new Cell Class Name
+ (DownloadItemCell*) createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DownloadItemCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <DownloadItemCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((DownloadItemCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (DownloadItemCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"DownloadItemCell";
}

+ (CGFloat)getCellHeight
{
    return 160.0f;
}

@end
