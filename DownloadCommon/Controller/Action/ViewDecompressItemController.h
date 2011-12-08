//
//  ViewDirectoryController.h
//  Download
//
//  Created by gckj on 11-11-25.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "CommonFileActionController.h"

@interface ViewDecompressItemController : PPTableViewController<CommonFileActionProtocol>

@property(nonatomic, retain) NSArray* decompressItemList;

- (void) loadDataFromDecompressArray;
@end
