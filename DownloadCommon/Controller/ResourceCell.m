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
@synthesize downloadCountButton;
@synthesize siteNameLabel;
@synthesize fileTypeButton;

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
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:RESOURCE_CELL_SELECTED_BG_IMAGE];
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
        [self.fileTypeButton setTitle:fileType forState:UIControlStateNormal];
    }
        else{
        [self.fileTypeButton setTitle:NSLS(@"kFileType_other") forState:UIControlStateNormal];
    }
    
    [self setFileTypeBgImage:fileType];
}

- (void)setFileTypeBgImage:(NSString*)fileType
{
    FileTypeManager* manager = [FileTypeManager defaultManager];
    if ([manager isImage:fileType]) {
        [self.fileTypeButton setBackgroundImage:IMAGETYPE_LABEL_BG_IMAGE forState:UIControlStateNormal];
    } else if ([manager isVideoAudio:fileType]) {
        [self.fileTypeButton setBackgroundImage:AUDIOTYPE_LABEL_BG_IMAGE forState:UIControlStateNormal];

    } else {
        [self.fileTypeButton setBackgroundImage:ALLTYPE_LABEL_BG_IMAGE forState:UIControlStateNormal];

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
        NSString *count = [NSString stringWithFormat:NSLS(@"kDownloadCount"), downloadCount];  
        [self.downloadCountButton setTitle:count forState:UIControlStateNormal];
    }
    else{
        [self.downloadCountButton setTitle:@"" forState:UIControlStateNormal];
    }
    [self.downloadCountButton setBackgroundImage:DOWNLOADCOUNT_LABEL_BG_IMAGE forState:UIControlStateNormal];
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

- (void)setCellSelectedColor
{
    self.siteNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.siteUrlLabel.textColor = [UIColor colorWithRed:112/255.0 green:144/255.0 blue:165/255.0 alpha:1.0];
    [self.downloadCountButton setBackgroundImage:DOWNLOADCOUNT_LABEL_SELECT_BG_IMAGE forState:UIControlStateNormal];
    self.accessoryView = [[UIImageView alloc] initWithImage:ACCESSORY_ICON_SELECT_IMAGE];
    
}

- (void)resetCellColor
{
    self.siteNameLabel.textColor = [UIColor colorWithRed:123/255.0 green:134/255.0 blue:148/255.0 alpha:1.0];
    self.siteUrlLabel.textColor = [UIColor colorWithRed:189/255.0 green:199/255.0 blue:211/255.0 alpha:1.0];
    [self.downloadCountButton setBackgroundImage:DOWNLOADCOUNT_LABEL_BG_IMAGE forState:UIControlStateNormal];
    self.accessoryView = [[UIImageView alloc] initWithImage:ACCESSORY_ICON_IMAGE];
}

- (void)dealloc {
    [siteNameLabel release];
    [siteUrlLabel release];
    [downloadCountButton release];
    [fileTypeButton release];
    [super dealloc];
}
@end
