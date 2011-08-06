//
//  SearchHistory.h
//  groupbuy
//
//  Created by qqn_pipi on 11-8-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchHistory : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSDate * lastModified;

@end
