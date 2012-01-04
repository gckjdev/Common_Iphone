//
//  WallpaperController.m
//  Download
//
//  Created by gckj on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WallpaperController.h"
#import "DownloadResource.h"
#import "MWPhotoBrowser.h"
#import "DownloadItem.h"

@implementation WallpaperController

@synthesize currentIndex;
@synthesize tipsLabel;
@synthesize browser;

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
    [tipsLabel release];
    [browser release];
}

- (void)showTips:(NSString *)text
{ 
    if (self.tipsLabel == nil) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
        [label setFont:[UIFont systemFontOfSize:14]];
        self.tipsLabel = label;
        [label release];
        [self.tipsLabel setTextAlignment:UITextAlignmentCenter];
        [self.view addSubview:self.tipsLabel];
        [self.tipsLabel setBackgroundColor:[UIColor clearColor]];
        [self.tipsLabel setTextColor:BUTTON_TEXT_NORMAL_COLOR];
        
    }
    [self.tipsLabel setText:text];
    [self.tipsLabel setHidden:NO];
}

- (void)hideTips
{
    [self.tipsLabel setHidden:YES];
}

- (void)showWallpaper:(int)indexValue
{
    if (indexValue >= 0) {
        currentIndex = indexValue;
    }
    
    NSArray *itemList = [self findAllRelatedItems];
    
    if ([itemList count] == 0) {
        [self showTips:NSLS(@"kNoWallpaper")];
        return;
    }
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (DownloadItem *item in itemList) {
        [photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:item.localPath]]];
    }
    
    browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:indexValue]; 

    self.view.frame = self.view.bounds;
    CGRect frame = [self.view bounds];
    [browser.view setFrame:frame];
    [self.view addSubview:browser.view];
    
    [browser removeDoneButtonItem];
   [photos release];

}

#pragma mark - View lifecycle
- (void)viewDidAppear:(BOOL)animated
{  

}

- (void)viewDidLoad
{    
    [self setBackgroundImageName:DOWNLOAD_BG];
    [self setDownloadNavigationTitle:NSLS(@"kWallpaper")];    
    [[[self navigationController] navigationBar] setHidden:YES];
    
    [self showWallpaper:0];

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

@end
