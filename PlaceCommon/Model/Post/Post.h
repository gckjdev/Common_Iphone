//
//  Post.h
//  Dipan
//
//  Created by qqn_pipi on 11-5-14.
//  Copyright (c) 2011骞�__MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

enum {
    POST_FOR_PLACE,
    POST_FOR_NEARBY,
    POST_FOR_FOLLOW,
    POST_FOR_ATME,
};

@interface Post : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * postId;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * textContent;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * contentType;
@property (nonatomic, retain) NSDate   * createDate;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * totalView;
@property (nonatomic, retain) NSNumber * totalForward;
@property (nonatomic, retain) NSNumber * totalQuote;
@property (nonatomic, retain) NSNumber * totalReply;
@property (nonatomic, retain) NSNumber * totalRelated;
@property (nonatomic, retain) NSNumber * userLongitude;
@property (nonatomic, retain) NSNumber * userLatitude;
@property (nonatomic, retain) NSNumber * useFor;
@property (nonatomic, retain) NSNumber * deleteFlag;
@property (nonatomic, retain) NSNumber * deleteTimeStamp;
@property (nonatomic, retain) NSString * userNickName;
@property (nonatomic, retain) NSString * srcPostId;
@property (nonatomic, retain) NSString * replyPostId;
@property (nonatomic, retain) NSString * userAvatar;
@property (nonatomic, retain) NSString * userGender;

@end
