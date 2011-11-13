//
//  PlayAudioVideoController.m
//  Download
//
//  Created by  on 11-11-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayAudioVideoController.h"

#import "DownloadItem.h"
#import "FileUtil.h"

@implementation PlayAudioVideoController

@synthesize downloadItem;
@synthesize player;

- (void)showPlayerView
{
    NSURL* url = [NSURL fileURLWithPath:downloadItem.localPath];    
    self.player = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
    CGRect frame = [self.view bounds];
    [[player view] setFrame:frame]; // size to fit parent view exactly
    [self.view addSubview:[player view]];
    [player play];
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
    [player release];
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
    [player stop];    
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
