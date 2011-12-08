//
//  DisplayReadableFileController.m
//  Download
//
//  Created by  on 11-11-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DisplayReadableFileController.h"
#import "DownloadItem.h"
#import "DecompressItem.h"
#import "DownloadItemManager.h"

@implementation DisplayReadableFileController

@synthesize downloadItem;
@synthesize decompressItem;
@synthesize docController;
@synthesize superViewController;
@synthesize previewController;
@synthesize itemList;

- (void)quickLookPreview:(UIViewController*)viewController downloadItem:(DownloadItem*)item index:(int)index
{    
    if ([QLPreviewController canPreviewItem:item] == NO){
        [UIUtils alert:NSLS(@"kCannotPreviewFile")];
        return;
    }
    
    BOOL isItemChange = NO;
    if (self.downloadItem != item){
        self.downloadItem = item;
        isItemChange = YES;
    }

    self.superViewController = viewController;
    
    if (self.previewController == nil){
        self.previewController = [[[QLPreviewController alloc] init] autorelease];
        self.previewController.delegate = self;          
        self.previewController.dataSource = self;      
    }    
    self.previewController.currentPreviewItemIndex = index;    
    [self.superViewController.navigationController pushViewController:self.previewController animated:YES];
}

- (void)quickLookPreview:(UIViewController*)viewController decompressItem:(DecompressItem*)item
{    
    if ([QLPreviewController canPreviewItem:item] == NO){
        [UIUtils alert:NSLS(@"kCannotPreviewFile")];
        return;
    }
    
    BOOL isItemChange = NO;
    if (self.decompressItem != item){
        self.decompressItem = item;
        isItemChange = YES;
    }
    
    self.superViewController = viewController;
    
    if (self.previewController == nil){
        self.previewController = [[[QLPreviewController alloc] init] autorelease];
        self.previewController.delegate = self;          
        self.previewController.dataSource = self;                
    }    
    
    [self.superViewController.navigationController pushViewController:self.previewController animated:YES];
}

- (void)docControllerPreview:(UIViewController*)viewController downloadItem:(DownloadItem*)item
{
    if ([QLPreviewController canPreviewItem:item] == NO){
        [UIUtils alert:NSLS(@"kCannotPreviewFile")];
        return;
    }
    
    BOOL isItemChange = NO;
    if (self.downloadItem != item){
        self.downloadItem = item;
        isItemChange = YES;
    }
    
    self.superViewController = viewController;
    
    NSURL* url = [NSURL fileURLWithPath:downloadItem.localPath];    
    if (self.docController == nil){
        self.docController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docController.delegate = self;          
    }

    if (isItemChange){        
        [self.docController setURL:url];
    }

    [self.docController presentPreviewAnimated:YES];    
}

- (NSArray*)findAllRelatedItems
{
    return [[DownloadItemManager defaultManager] findAllReadableItems];
}

- (void)preview:(UIViewController*)viewController downloadItem:(DownloadItem*)item
{
    self.itemList = [NSArray arrayWithObject:item];    
    [self quickLookPreview:viewController downloadItem:item index:0];
}

- (void)preview:(UIViewController*)viewController itemList:(NSArray*)list index:(int)indexValue
{
    self.itemList = list;
    [self quickLookPreview:viewController downloadItem:[list objectAtIndex:indexValue] index:indexValue];
}

- (void)preview:(UIViewController *)viewController decompressItem:(DecompressItem *)item
{
    self.itemList = [NSArray arrayWithObject:item];    
    [self quickLookPreview:viewController decompressItem:item];
}

- (void)showPlayerView
{
    NSURL* url = [NSURL fileURLWithPath:downloadItem.localPath];    
    
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    self.docController.delegate = self;  
    [self.docController presentPreviewAnimated:NO];
}

- (void)show:(UIView*)superView;
{
    [self.view setFrame:superView.bounds];
    [superView addSubview:self.view];
    [self showPlayerView];
}

- (id)initWithDownloadItem:(DownloadItem*)item
{
    self = [super init];
    self.downloadItem = item;
    return self;
}

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

- (void)dealloc
{
    [itemList release];
    [previewController release];
    [docController release];
    [downloadItem release];
    [superViewController release];
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

#pragma UIDocument Controller Delegate

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return self.superViewController;
}

- (UIView *) documentInteractionControllerViewForPreview: (UIDocumentInteractionController *) controller
{
    return self.superViewController.view;
}

- (CGRect) documentInteractionControllerRectForPreview: (UIDocumentInteractionController *) controller
{
    return self.superViewController.view.bounds;
}

#pragma Quick Look Delegate

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return [itemList count];
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    return [itemList objectAtIndex:index];
}

@end
