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

#define global_queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation MusicPlayController

@synthesize mdAudioPlayerController;
@synthesize displayMDAudioPlayerController;


- (NSArray*)findAllRelatedItems
{
    return [[DownloadItemManager defaultManager] findAllAudioItems];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
               
        //mdAudioPlayerController = [[MDAudioPlayerController alloc] init];

    }
    return self;
}

- (void)dealloc {
    [mdAudioPlayerController release];
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
    
  //  dispatch_async(global_queue, ^{
        
        NSMutableArray *songs = [[NSMutableArray alloc] init];
        
        NSArray *list = [self findAllRelatedItems];
        for (DownloadItem* item in list)
        {
            MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:item.localPath]];
            [songs addObject:audioFile];
        }
        
        
        [self setSoundFiles:songs selectedIndex:0];
//        [self playBySelectedIndex];
    
        
        [songs release];

        
 //    });

}




- (void)viewDidAppear:(BOOL)animated
{
    
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
