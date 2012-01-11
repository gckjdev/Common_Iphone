//
//  MusicPlayController.m
//  Download
//
//  Created by Orange on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MusicPlayController.h"
#import "MDAudioFile.h"
#import "MDAudioPlayerController.h"
#import "DownloadItem.h"
#import "DownloadItemManager.h"

@implementation MusicPlayController

//@synthesize songs;

- (NSArray*)findAllRelatedItems
{
    return [[DownloadItemManager defaultManager] findAllAudioItems];
}

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
        
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)showMusicPlayer:(BOOL)play index:(int)indexValue
{
    NSMutableArray *songs = [[NSMutableArray alloc] init];
    NSArray *list = [self findAllRelatedItems];
    
    //下载列表为空
    if ([list count] == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [[self artworkView] setUserInteractionEnabled:NO];
        [[self playButton] setUserInteractionEnabled:NO];
        
        [self setSoundFiles:nil selectedIndex:0];
        
        self.titleLabel.text = NSLS(@"kNoMusicToPlay");
        [[self artworkView] setImage:[UIImage imageNamed:@"AudioPlayerNoArtwork.png"] forState:UIControlStateNormal]; 
        return;
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [[self artworkView] setUserInteractionEnabled:YES];
        [[self playButton] setUserInteractionEnabled:YES];
    }

    for (DownloadItem* item in list)
    {
        MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:item.localPath]];
        [songs addObject:audioFile];
    }
    
    //更新播放列表
    [self.songTableView reloadData];
    
       
    //在Download列表里点击播放
    if (play) {
        [self setSoundFiles:songs selectedIndex:indexValue];
        [self playBySelectedIndex];
    } 
    
    //点击MusicTab时
    else {
        if (self.player.playing == NO) {
            [self setSoundFiles:songs selectedIndex:indexValue];
        }
    } 
        
    [songs release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showMusicPlayer:NO index:0];
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
