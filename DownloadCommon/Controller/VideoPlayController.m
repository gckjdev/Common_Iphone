//
//  MusicPlayController.m
//  Download
//
//  Created by Orange on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "VideoPlayController.h"
#import "DownloadItemManager.h"
#import "DownloadItem.h"
#import "DownloadResource.h"
#import "UIViewController+DownloadViewControllerAddition.h"

@implementation VideoPlayController

@synthesize currentIndex;
@synthesize tipsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

- (void)showVideoPlayer:(BOOL)play index:(int)indexValue
{
    if (indexValue >= 0) {
        currentIndex = indexValue;
    }
    
    NSArray *itemList = [self findAllRelatedItems];
    
    if ([itemList count] == 0) {

        [self showTips:NSLS(@"kNoVideo")];
        return;
    }
    
    if (self.player != nil && !play) {
        return;
    }
    
    [self hideTips];
    
    DownloadItem *item = [itemList objectAtIndex:indexValue];
    NSURL* url = [NSURL fileURLWithPath:item.localPath];    
    if (self.player == nil){
        [self setDownloadItem:item];
        self.player = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
        self.view.frame = self.view.bounds;
        CGRect frame = [self.view bounds];
        [[self.player view] setFrame:frame]; // size to fit parent view exactly
        [self.view addSubview:self.player.view];
        
        
    }
    else{
        if (self.downloadItem != item){
            [self setDownloadItem:item];
            [self.player setContentURL:url];
        }
    }
    
    [self updateNavigationTitle:item.fileName];
    [self.player play];   
}

- (void)clickPrevious:(id)sender
{
    if (currentIndex > 0) {
        [self setCurrentIndex:currentIndex-1];
        
        NSArray *itemList = [self findAllRelatedItems];
        DownloadItem *item = [itemList objectAtIndex:currentIndex];
        NSURL* url = [NSURL fileURLWithPath:item.localPath]; 
        [self updateNavigationTitle:item.fileName];
        [self.player setContentURL:url];
        [self.player play];
    } else {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLS(@"kTips") message:NSLS(@"kAlreadyFirst") delegate:self cancelButtonTitle:NSLS(@"kOK") otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
}

- (void)clickNext:(id)sender
{
    NSArray *itemList = [self findAllRelatedItems];
    int totalCount = [itemList count];
    if (currentIndex < totalCount-1) {
        [self setCurrentIndex:currentIndex+1];
        
        DownloadItem *item = [itemList objectAtIndex:currentIndex];
        NSURL* url = [NSURL fileURLWithPath:item.localPath]; 
        [self updateNavigationTitle:item.fileName];
        [self.player setContentURL:url];
        [self.player play];
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLS(@"kTips") message:NSLS(@"kAlreadyLast") delegate:self cancelButtonTitle:NSLS(@"kOK") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    [self setPreviousButton];
    [self setNextButton];
    [self setBackgroundImageName:DOWNLOAD_BG];
    [self setDownloadNavigationTitle:NSLS(@"kVideo")];

    [super viewDidLoad];
       
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showVideoPlayer:NO index:0];
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
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
//    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
//        return(YES);
//    }
//    
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            MPMoviePlayerViewController * vc = [[[MPMoviePlayerViewController alloc] initWithContentURL:nil ] autorelease];
            [self presentMoviePlayerViewControllerAnimated:vc];
            [vc.moviePlayer play];

    }
    return NO;
}

@end
