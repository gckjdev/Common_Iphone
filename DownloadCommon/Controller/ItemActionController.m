//
//  ItemActionController.m
//  Download
//
//  Created by  on 11-11-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ItemActionController.h"
#import "PlayAudioVideoController.h"
#import "DisplayReadableFileController.h"
#import "DownloadItem.h"

@implementation ItemActionController

@synthesize item;
@synthesize playItemController;
@synthesize playItemSuperView;

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
    [playItemController release];
    [item release];
    [playItemSuperView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (UIViewController<CommonFileActionProtocol>*)getViewControllerByItem:(DownloadItem*)downloadItem
{
    if ([downloadItem isAudioVideo]){
        return [[[PlayAudioVideoController alloc] initWithDownloadItem:downloadItem] autorelease];
    }
    else if ([downloadItem isReadableFile]){
        return [[[DisplayReadableFileController alloc] initWithDownloadItem:downloadItem] autorelease];
    }
    else{
        return [[[DisplayReadableFileController alloc] initWithDownloadItem:downloadItem] autorelease];
    }
}

- (void)createPlayItemView
{
    self.playItemController = [self getViewControllerByItem:self.item];
    [self.playItemController show:self.playItemSuperView];    
}

- (void)showItem:(DownloadItem*)newItem
{
    if (self.item != newItem){
        self.item = newItem;
        [self createPlayItemView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPlayItemSuperView:nil];
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
