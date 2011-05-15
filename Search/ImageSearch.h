//
//  ImageSearch.h
//  three20test
//
//  Created by qqn_pipi on 10-4-11.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicSearch.h"

enum SearchImageSize {
	kSearchImageSizeIcon
};

#define SearchImageSizeIcon		@"imgsz=icon"
#define SearchImageSizeNormal	@"imgsz=medium"
#define SearchImageSizeLarge	@"imgsz=xlarge"

@interface ImageSearch : BasicSearch <BasicSearchProtocol> {

	int		imageSize;
	
}

- (NSString*)getImageSizeString;
- (NSMutableArray*)searchImageBySize:(CGSize)size searchText:(NSString *)searchText location:(CLLocation *)location searchSite:(NSString*)searchSite startPage:(int)startPage maxResult:(int)maxResult;

- (NSMutableArray*)searchFlickrImage:(NSString*)searchText;

+ (NSString*)getFlickrPhotoBigURL:(NSDictionary*)photoDict;
+ (NSString*)getFlickrPhotoThumURL:(NSDictionary*)photoDict;


@end
