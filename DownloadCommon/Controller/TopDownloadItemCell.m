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
#import "DownloadResource.h"

@implementation TopDownloadItemCell
@synthesize rankLabel;
@synthesize fileNameLabel;
@synthesize totalDownloadButton;
@synthesize fileTypeButton;
@synthesize webSiteNameLabel;

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	UIImageView *view= [[UIImageView alloc] initWithImage:RESOURCE_CELL_BG_IMAGE];
    view.frame = self.bounds;
    self.backgroundView = view;
    [view release];
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
    
    
    TopDownloadItemCell* cell = (TopDownloadItemCell*)[topLevelObjects objectAtIndex:0];
    cell.delegate = delegate;
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:RESOURCE_CELL_SELECTED_BG_IMAGE];
    bgView.frame = cell.bounds;
    cell.selectedBackgroundView = bgView;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [bgView release];

    
    return cell;
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
    [self.totalDownloadButton setBackgroundImage:DOWNLOADCOUNT_LABEL_BG_IMAGE forState:UIControlStateNormal];
    if ([item isAudioVideo]) {
        [self.fileTypeButton setBackgroundImage:AUDIOTYPE_LABEL_BG_IMAGE forState:UIControlStateNormal];
    } else if ([item isImageFileType]) {
        [self.fileTypeButton setBackgroundImage:IMAGETYPE_LABEL_BG_IMAGE forState:UIControlStateNormal];
    } else {
        [self.fileTypeButton setBackgroundImage:ALLTYPE_LABEL_BG_IMAGE forState:UIControlStateNormal];
    }
    
//  self.rankLabel.text = [NSString stringWithFormat:@"%d", [indexPathValue row] + 1];
    
    [self.fileTypeButton setTitle:item.fileType forState:UIControlStateNormal]; 
    
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
    NSString *count = [NSString stringWithFormat:NSLS(@"kDownloadCount"), item.totalDownload];
    [self.totalDownloadButton setTitle:count forState:UIControlStateNormal];
    
}

- (void)setCellSelectedColor
{
    self.fileNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.webSiteNameLabel.textColor = [UIColor colorWithRed:112/255.0 green:144/255.0 blue:165/255.0 alpha:1.0];
    [self.totalDownloadButton setBackgroundImage:DOWNLOADCOUNT_LABEL_SELECT_BG_IMAGE forState:UIControlStateNormal];
//    self.accessoryView = [[UIImageView alloc] initWithImage:ACCESSORY_ICON_SELECT_IMAGE];
    
}

- (void)resetCellColor
{
    self.fileNameLabel.textColor = [UIColor colorWithRed:123/255.0 green:134/255.0 blue:148/255.0 alpha:1.0];
    self.webSiteNameLabel.textColor = [UIColor colorWithRed:189/255.0 green:199/255.0 blue:211/255.0 alpha:1.0];
    [self.totalDownloadButton setBackgroundImage:DOWNLOADCOUNT_LABEL_BG_IMAGE forState:UIControlStateNormal];
//    self.accessoryView = [[UIImageView alloc] initWithImage:ACCESSORY_ICON_IMAGE];
}


- (void)dealloc
{
    [webSiteNameLabel release];
    [fileTypeButton release];
    [totalDownloadButton release];
    [fileNameLabel release];
    [rankLabel release];
    
}

@end
