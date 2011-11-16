//
//  TopDownloadItemCell.m
//  Download
//
//  Created by gckj on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopDownloadItemCell.h"
#import "TopDownloadItem.h"
#import "LocaleUtils.h"

@implementation TopDownloadItemCell
@synthesize rankLabel;
@synthesize fileNameLabel;
@synthesize totalDownloadLabel;
@synthesize fileTypeLabel;
@synthesize webSiteNameLabel;

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		   
}

- (void)awakeFromNib{
    [self setCellStyle];
} 

+ (TopDownloadItemCell*) createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TopDownloadItemCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <TopDownloadItemCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((TopDownloadItemCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (TopDownloadItemCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"TopDownloadItemCell";
}

+ (CGFloat)getCellHeight
{
    return 50;
}

- (void)setCellInfoWithTopDownloadItem:(TopDownloadItem*)item atIndexPath:(NSIndexPath*)indexPathValue
{
    self.rankLabel.text = [NSString stringWithFormat:@"%d", [indexPathValue row] + 1];
    self.fileTypeLabel.text = item.fileType;
    if ([item.fileName length] > 0){
        self.fileNameLabel.text = item.fileName;
    } else {
        self.fileNameLabel.text = [item.url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    }
    if ([item.webSiteName length] > 0) {
        self.webSiteNameLabel.text = [NSString stringWithFormat:NSLS(@"kFromWebSite"), item.webSiteName];
    } else {
        self.webSiteNameLabel.text = [NSString stringWithFormat:NSLS(@"kFromWebSite"), item.webSite];
    }    
    self.totalDownloadLabel.text = [NSString stringWithFormat:NSLS(@"kDownloadCount"), item.totalDownload];
}

- (void)dealloc
{
    [webSiteNameLabel release];
    [fileTypeLabel release];
    [totalDownloadLabel release];
    [fileNameLabel release];
    [rankLabel release];
    
}

@end
