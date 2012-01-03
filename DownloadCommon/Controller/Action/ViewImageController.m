//
//  ViewImageController.m
//  Download
//
//  Created by gckj on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewImageController.h"
#import "MWPhotoBrowser.h"
#import "DownloadItem.h"
#import "DecompressItem.h"
#import "LogUtil.h"
#import "DownloadItemManager.h"
#import "DownloadAppDelegate.h"
@implementation ViewImageController
@synthesize downloadItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [downloadItem release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithDownloadItem:(DownloadItem*)item
{
    self = [super init];
    self.downloadItem = item;
    return self;
}

- (void)show:(UIView*)superView
{
    
}

- (NSArray*)findAllRelatedItems
{
    return [[DownloadItemManager defaultManager] findAllImageDownloadItem];
}

- (void)preview:(UIViewController*)viewController image:(UIImage*)image
{
    NSMutableArray *photos = [NSMutableArray array];
    [photos addObject:[MWPhoto photoWithImage:image]];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        
//    [viewController.navigationController pushViewController:browser animated:YES];
  
    [viewController presentModalViewController:browser animated:YES];
    
    [browser release];
}

- (void)preview:(UIViewController*)viewController downloadItem:(DownloadItem*)item
{
    NSMutableArray *photos = [NSMutableArray array];
    [photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:item.localPath]]];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    
//    self.view.frame = viewController.view.bounds;
//    CGRect frame = [self.view bounds];
//    [[browser view] setFrame:frame]; // size to fit parent view exactly
//    [self.view addSubview:browser.view];
//    [self.navigationItem setTitle:downloadItem.fileName];
    
//    [viewController.navigationController pushViewController:browser animated:YES];
    [viewController presentModalViewController:browser animated:YES];
    
    [browser release];
}

- (void)preview:(UIViewController *)viewController decompressItem:(DecompressItem *)item
{
    NSMutableArray *photos = [NSMutableArray array];
    [photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:item.localPath]]];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        
    [viewController presentModalViewController:browser animated:YES];
    
    [browser release];
}

- (void)preview:(UIViewController*)viewController itemList:(NSArray*)list index:(int)indexValue
{
    DownloadAppDelegate *delegate = (DownloadAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate hasWallpaperTab]) {
        WallpaperController *wallpaperController = [delegate getWallpaperTab];
        [wallpaperController showWallpaper:indexValue];
        [delegate gotoWallpaperTab];
        return;
    }
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    if ([[list objectAtIndex:0] isKindOfClass:[DownloadItem class]]) {
        for (DownloadItem *item in list) {
            PPDebug(@"add photo (%@)", item.localPath);
            [photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:item.localPath]]];
        }
    }
    else if ([[list objectAtIndex:0] isKindOfClass:[DecompressItem class]]) {
        for (DecompressItem *item in list) {
            PPDebug(@"add photo (%@)", item.localPath);
            [photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:item.localPath]]];
        }
    }
    
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:indexValue]; 
    
//    [viewController.navigationController pushViewController:browser animated:YES];
    [viewController presentModalViewController:browser animated:YES];
    
    [photos release];
    [browser release];
}
@end
