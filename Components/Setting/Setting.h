//
//  Setting.h
//  ___PROJECTNAME___
//
//  Created by qqn_pipi on 10-10-3.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#define kSettingStringTable	@"Setting"
#define kRowOn			0
#define kRowOff			1
#define kOnString		NSLocalizedStringFromTable(@"ON", kSettingStringTable, nil)
#define kOffString		NSLocalizedStringFromTable(@"OFF", kSettingStringTable, nil)

@interface Setting :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * updateBy;
@property (nonatomic, retain) NSDate * updateDate;

@end



