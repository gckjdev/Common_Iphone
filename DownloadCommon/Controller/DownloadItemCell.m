//
//  DownloadItemCell.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DownloadItemCell.h"
#import "DownloadItem.h"
#import "LocaleUtils.h"
#import "DownloadResource.h"

@implementation DownloadItemCell
@synthesize starButton;
@synthesize webSiteLabel;
@synthesize pauseButton;
@synthesize fileTypeLabel;
@synthesize fileNameLabel;
@synthesize statusLabel;
@synthesize downloadProgress;
@synthesize downloadDetailLabel;

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *view= [[UIImageView alloc] initWithImage:DOWNLOAD_CELL_BG_IMAGE];
    view.frame = self.bounds;
    self.backgroundView = view;
    [view release];
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
    
    DownloadItemCell* cell = (DownloadItemCell*)[topLevelObjects objectAtIndex:0];
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
    return @"DownloadItemCell";
}

+ (CGFloat)getCellHeight
{
    return 106.0f;
}

#define SIZE_ONE_MB (1000000.0)
#define SIZE_ONE_KB (1000.0)

- (NSString*)getSizeInfo:(DownloadItem*)item
{
    double downloadSize = [item.downloadSize doubleValue];
    double totalSize = [item.fileSize doubleValue];    
    
    if ([item.status intValue] == DOWNLOAD_STATUS_FINISH){                
        if (totalSize >= SIZE_ONE_MB || downloadSize >= SIZE_ONE_MB){
            return [NSString stringWithFormat:@"%.2f MB", totalSize/SIZE_ONE_MB];
        }
        else{
            return [NSString stringWithFormat:@"%.2f KB", totalSize/SIZE_ONE_KB];        
        }            
    }
    else{
        if (totalSize >= SIZE_ONE_MB || downloadSize >= SIZE_ONE_MB){
            return [NSString stringWithFormat:@"%.2f/%.2f MB", downloadSize/SIZE_ONE_MB, totalSize/SIZE_ONE_MB];
        }
        else{
            return [NSString stringWithFormat:@"%.2f/%.2f KB", downloadSize/SIZE_ONE_KB, totalSize/SIZE_ONE_KB];        
        }    
    }
}

- (NSString*)getPercentageInfo:(DownloadItem*)item
{
    double downloadSize = [item.downloadSize doubleValue];
    double totalSize = [item.fileSize doubleValue];    

    if ([item.status intValue] == DOWNLOAD_STATUS_FINISH){
        return @"";
    }
    
    if (totalSize > 0.0f){
        return [NSString stringWithFormat:@"%d%%", (int)((downloadSize/totalSize)*100)]; 
    }
    else{
        return @"";
    }
}

- (NSString*)getLeftInfo:(DownloadItem*)item
{
    return @""; // TODO
}

- (void)setPauseButtonInfo:(DownloadItem*)item
{
    
    [self.pauseButton setBackgroundImage:ACTION_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.pauseButton setBackgroundImage:ACTION_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];

    [self.pauseButton setHidden:NO];
    if ([item canPause]){
        [self.pauseButton setTitle:NSLS(@"Pause") forState:UIControlStateNormal];
    }
    else if ([item canResume]){
        [self.pauseButton setTitle:NSLS(@"Resume") forState:UIControlStateNormal];
    }
    else if ([item isDownloadFinished]){
        if ([item isAudioVideo]){
            [self.pauseButton setTitle:NSLS(@"Play") forState:UIControlStateNormal];        
        }
        else if ([item canView]){
            [self.pauseButton setTitle:NSLS(@"View") forState:UIControlStateNormal];        
        }
        else if ([item isZipFile]){
            [self.pauseButton setTitle:NSLS(@"Open") forState:UIControlStateNormal];        
        }
        else if ([item isRarFile]){
            [self.pauseButton setTitle:NSLS(@"Open") forState:UIControlStateNormal];        
        }
        else{
            [self.pauseButton setTitle:@"" forState:UIControlStateNormal];
            [self.pauseButton setHidden:YES];            
        }
    }             
    else{
        [self.pauseButton setTitle:@"" forState:UIControlStateNormal];
        [self.pauseButton setHidden:YES];
    }
}

- (void)setLabel:(UILabel *)label Background:(UIImage *)image
{
//    CALayer *layer = [[CALayer alloc]init];
//    layer.frame = label.bounds;
//    layer.contents = (id)image.CGImage;
//    [label.layer insertSublayer:layer atIndex:0];
//    layer.backgroundColor = [UIColor clearColor].CGColor;
//    [layer release];

}

- (void)setCellInfoWithItem:(DownloadItem*)item indexPath:(NSIndexPath*)indexPath
{
    if ([item canPlay]) {
        self.fileTypeLabel.backgroundColor = [UIColor colorWithPatternImage:AUDIOTYPE_LABEL_BG_IMAGE];
    } else if ([item canView]) {
        self.fileTypeLabel.backgroundColor = [UIColor colorWithPatternImage:IMAGETYPE_LABEL_BG_IMAGE];
    } else {
        self.fileTypeLabel.backgroundColor = [UIColor colorWithPatternImage:ALLTYPE_LABEL_BG_IMAGE];
    }
        
    self.fileTypeLabel.opaque = YES;
    
    self.fileTypeLabel.text = [item.fileName pathExtension];
    self.fileNameLabel.text = item.fileName;
    self.statusLabel.text = [item statusText];    
    
    NSString* sizeInfo = [self getSizeInfo:item];
    NSString* percentageInfo = [self getPercentageInfo:item];
    NSString* leftInfo = [self getLeftInfo:item];    
    self.downloadDetailLabel.text = [NSString stringWithFormat:@"%@ %@ %@", sizeInfo, percentageInfo, leftInfo];
    self.downloadProgress.progress = [item.downloadProgress floatValue];
    
    self.webSiteLabel.text = [NSString stringWithFormat:NSLS(@"kFromWebSite"), item.webSite];
    
    [self setPauseButtonInfo:item];
    
//    if ([item isDownloadFinished]){
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    else{
//        self.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    if ([item isStarred]){
        [self.starButton setSelected:YES];
    }
    else{
        [self.starButton setSelected:NO];
    }
}

- (IBAction)clickPause:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickPause:atIndexPath:)])
        [delegate clickPause:sender atIndexPath:self.indexPath];
}

- (IBAction)clickStar:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(clickPause:atIndexPath:)])
        [delegate clickStar:sender atIndexPath:self.indexPath];    
}

- (void)dealloc {
    [fileTypeLabel release];
    [fileNameLabel release];
    [statusLabel release];
    [downloadDetailLabel release];
    [downloadProgress release];
    [pauseButton release];
    [starButton release];
    [webSiteLabel release];
    [super dealloc];
}
@end
