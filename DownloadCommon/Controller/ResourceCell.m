//
//  ResourceCell.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ResourceCell.h"
#import "TopSite.h"
#import "LocaleUtils.h"
#import "Site.h"
#import "DownloadResource.h"
#import "FileTypeManager.h"

@implementation ResourceCell
@synthesize siteUrlLabel;
@synthesize downloadCountLabel;
@synthesize siteNameLabel;
@synthesize fileTypeLabel;

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		
    self.accessoryView = [[UIImageView alloc] initWithImage:ACCESSORY_ICON_IMAGE];
    
    UIImageView *view= [[UIImageView alloc] initWithImage:RESOURCE_CELL_BG_IMAGE];
    view.frame = self.bounds;
    self.backgroundView = view;
    [view release];
}

- (void)awakeFromNib{
    [self setCellStyle];
} 

// just replace ProductDetailCell by the new Cell Class Name
+ (ResourceCell*) createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ResourceCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ResourceCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ResourceCell* cell = (ResourceCell*)[topLevelObjects objectAtIndex:0];
    cell.delegate = delegate;
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:DOWNLOAD_CELL_SELECTED_BG_IMAGE];
    bgView.frame = cell.bounds;
    cell.selectedBackgroundView = bgView;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [bgView release];
    
    return cell;
}

+ (NSString*)getCellIdentifier
{
    return @"ResourceCell";
}

+ (CGFloat)getCellHeight
{
    return 44;
}

- (void)setFileType:(NSString*)fileType
{
    if ([fileType length] > 0) {
        self.fileTypeLabel.text = fileType;

    }
        else{
        self.fileTypeLabel.text = NSLS(@"kFileType_other");
    }
    
    [self setFileTypeBgImage:fileType];
}

- (void)setFileTypeBgImage:(NSString*)fileType
{
    FileTypeManager* manager = [FileTypeManager defaultManager];
    if ([manager isImage:fileType]) {
        self.fileTypeLabel.backgroundColor = [UIColor colorWithPatternImage:IMAGETYPE_LABEL_BG_IMAGE];
    } else if ([manager isVideoAudio:fileType]) {
        self.fileTypeLabel.backgroundColor = [UIColor colorWithPatternImage:AUDIOTYPE_LABEL_BG_IMAGE];
    } else {
        self.fileTypeLabel.backgroundColor = [UIColor colorWithPatternImage:ALLTYPE_LABEL_BG_IMAGE];
    }

}

- (void)setSiteName:(NSString*)siteName siteURL:(NSString*)siteURL
{
    if ([siteName length] > 0)
        self.siteNameLabel.text = siteName;
    else{
        self.siteNameLabel.text = [siteURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    }        
}

- (void)setSiteURL:(NSString*)siteURL
{
    self.siteUrlLabel.text = siteURL;    
}

- (void)setDownloadCount:(int)downloadCount{
    if (downloadCount >= 0){
        self.downloadCountLabel.text = [NSString stringWithFormat:NSLS(@"kDownloadCount"), downloadCount];    
    }
    else{
        self.downloadCountLabel.text = @"";
    }
    self.downloadCountLabel.backgroundColor = [UIColor colorWithPatternImage:DOWNLOADCOUNT_LABEL_BG_IMAGE];
}

- (void)setCellInfoWithTopSite:(TopSite*)site atIndexPath:(NSIndexPath*)indexPath
{
    [self setFileType:site.siteFileType];
    [self setSiteName:site.siteName siteURL:site.siteURL];
    [self setSiteURL:site.siteURL];
    [self setDownloadCount:site.downloadCount];
}

- (void)setCellInfoWithSite:(Site*)site atIndexPath:(NSIndexPath*)indexPath
{
    
    [self setFileType:site.siteFileType];
    [self setSiteName:site.siteName siteURL:site.siteURL];
    [self setSiteURL:site.siteURL];
    [self setDownloadCount:-1];
}

- (void)dealloc {
    [siteNameLabel release];
    [siteUrlLabel release];
    [downloadCountLabel release];
    [fileTypeLabel release];
    [super dealloc];
}
@end
