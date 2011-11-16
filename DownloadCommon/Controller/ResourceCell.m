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

@implementation ResourceCell
@synthesize siteUrlLabel;
@synthesize downloadCountLabel;
@synthesize siteNameLabel;
@synthesize fileTypeLabel;

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    ((ResourceCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ResourceCell*)[topLevelObjects objectAtIndex:0];
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
    self.fileTypeLabel.text = fileType;    
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
