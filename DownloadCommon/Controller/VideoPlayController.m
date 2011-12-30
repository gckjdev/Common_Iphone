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

@implementation VideoPlayController

@synthesize currentIndex;

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

- (void)showVideoPlayer:(BOOL)play index:(int)indexValue
{
    if (indexValue >= 0) {
        currentIndex = indexValue;
    }
    
    NSArray *itemList = [self findAllRelatedItems];
    
    if ([itemList count] == 0) {
        return;
    }
    
    if (!play) {
        return;
    }
    
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
    
    [self.navigationItem setTitle:item.fileName];
    
    [self.player play];   
}

- (void)setPreviousButton
{
    float buttonHigh = 27.5;
    float backButtonLen = 60;
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, backButtonLen, buttonHigh)];
    [backButton setBackgroundImage:ITEM_BACK_ICON_IMAGE forState:UIControlStateNormal];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [backButton.titleLabel setFont:font];
    [backButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    [backButton setTitle:NSLS(@"kPrevious") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickPrevious:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
}

- (void)setNextButton
{
    float buttonHigh = 27.5;
    float nextButtonLen = 60;
        
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(218, 0, nextButtonLen, buttonHigh)];
    [nextButton setBackgroundImage:ITEM_NEXT_ICON_IMAGE forState:UIControlStateNormal];
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    [nextButton.titleLabel setFont:font];
    [nextButton setTitleColor:[UIColor colorWithRed:99/255.0 green:124/255.0 blue:141/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [nextButton setTitle:NSLS(@"kNext") forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];    
}


- (void)clickPrevious:(id)sender
{
    if (currentIndex > 0) {
        [self setCurrentIndex:currentIndex-1];
        
        NSArray *itemList = [self findAllRelatedItems];
        DownloadItem *item = [itemList objectAtIndex:currentIndex];
        NSURL* url = [NSURL fileURLWithPath:item.localPath]; 
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
