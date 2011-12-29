//
//  PlayAudioController.m
//  Download
//
//  Created by  on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlayAudioController.h"
#import "DownloadItem.h"
#import "DownloadItemManager.h"
#import "MDAudioPlayerController.h"
#import "MDAudioFile.h"
#import "DownloadAppDelegate.h"
#import "MusicPlayController.h"

@implementation PlayAudioController

@synthesize itemList;
@synthesize audioPlayer;
@synthesize currentItem;

- (void)dealloc
{
    [currentItem release];
    [audioPlayer release];
    [itemList release];
    [super dealloc];
}

- (id)initWithDownloadItem:(DownloadItem*)item
{
    self = [super init];
    return self;
}

- (void)show:(UIView*)superView
{
    
}

- (NSArray*)findAllRelatedItems
{
    return [[DownloadItemManager defaultManager] findAllAudioItems];
}

- (void)preview:(UIViewController*)viewController downloadItem:(DownloadItem*)item
{
    self.itemList = [NSArray arrayWithObject:item];
    [self preview:viewController itemList:itemList index:0];
}



- (void)preview:(UIViewController*)viewController itemList:(NSArray*)list index:(int)indexValue
{    
    DownloadAppDelegate *delegate = ((DownloadAppDelegate *)[UIApplication sharedApplication].delegate);
    
    NSMutableArray *songs = [[NSMutableArray alloc] init];
    for (DownloadItem* item in list)
    {
        MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:item.localPath]];
        [songs addObject:audioFile];
    }
    
    DownloadItem* newItem = [list objectAtIndex:indexValue];
    BOOL isChange = NO;
    if (self.currentItem != newItem){
        isChange = YES;
    }
    //check if is MusicDownload app
    if ([delegate hasMusicPlayerTab]) {
                
        MusicPlayController *musicPlayController = [delegate getMusicPlayerTab];
               
        if (isChange){
            // if file is changed, then play the file
            self.currentItem = newItem;
            [musicPlayController setSoundFiles:songs selectedIndex:indexValue];
            [musicPlayController playBySelectedIndex];
        }
        else{
            // else do nothing
             [musicPlayController resume];
        }
        
        [songs release];
        
        [delegate gotoMusicPlayerTab];  
        
        return;
    }
    
    self.itemList = list;
    if (self.audioPlayer == nil){
        self.audioPlayer = [[[MDAudioPlayerController alloc] initWithSoundFiles:songs atPath:nil andSelectedIndex:indexValue] autorelease];
    }
    
    if (isChange){
        // if file is changed, then play the file
        self.currentItem = newItem;
        [audioPlayer setSoundFiles:songs selectedIndex:indexValue];    
        [audioPlayer playBySelectedIndex];
    }
    else{
        // else do nothing
        [audioPlayer resume];
    }
    
//    [viewController presentModalViewController:self.audioPlayer animated:YES];	    
    [viewController.navigationController pushViewController:self.audioPlayer animated:YES];
    [songs release];
}

- (void)preview:(UIViewController *)viewController decompressItem:(DecompressItem *)item
{
}



@end
