//
//  GroupDataAZ.h
//  FreeSMS
//
//  Created by qqn_pipi on 11-1-9.
//  Copyright 2011 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSectionNull		@"#"
#define kSectionNotFound	(-1)


@interface GroupDataAZ : NSObject {

	int						totalSectionCount;
	NSMutableDictionary		*sectionLetterDict;
	NSMutableArray			*dataSectionArray;
	NSMutableArray			*sectionTitleArray;
}

@property (nonatomic, assign) int						totalSectionCount;
@property (nonatomic, retain) NSMutableDictionary		*sectionLetterDict;
@property (nonatomic, retain) NSMutableArray			*dataSectionArray;
@property (nonatomic, retain) NSMutableArray			*sectionTitleArray;

// create the object
+ (id)GroupDataWithArray:(NSArray*)originDataList;

// return data object by given (section,row)
- (NSObject*)dataForSection:(int)section row:(int)row;

// return section index by given letter
// for example, "A" return 0, "C" return 2, and "Z" return 3
- (int)sectionForLetter:(NSString*)letter;

- (NSString*)titleForSection:(int)section;

- (int)numberOfRowsInSection:(NSInteger)section;

@end
