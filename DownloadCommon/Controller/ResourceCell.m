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

@implementation ResourceCell
@synthesize siteUrlLabel;
@synthesize downloadCountLabel;
@synthesize siteNameLabel;
@synthesize fileTypeLabel;

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;		   
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

- (void)setCellInfoWithSite:(TopSite*)site atIndexPath:(NSIndexPath*)indexPath
{
    self.fileTypeLabel.text = site.siteFileType;
    if ([site.siteName length] > 0)
        self.siteNameLabel.text = site.siteName;
    else
        self.siteNameLabel.text = 
    self.siteUrlLabel.text = site.siteURL;
    self.downloadCountLabel.text = [NSString stringWithFormat:NSLS(@"kDownloadCount"), site.downloadCount];
}


- (void)dealloc {
    [siteNameLabel release];
    [siteUrlLabel release];
    [downloadCountLabel release];
    [fileTypeLabel release];
    [super dealloc];
}
@end
