//
//  UISearchHistoryView.h
//  three20test
//
//  Created by qqn_pipi on 10-4-6.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInfoClearHistory			NSLocalizedString(@"kInfoClearHistory", @"")
#define kInfoBack					NSLocalizedString(@"Back", @"")
#define kInfoClearHistoryNo			NSLocalizedString(@"No", @"")
#define kInfoClearHistoryYes		NSLocalizedString(@"Yes", @"")
#define kInfoConfirmClearHistory	NSLocalizedString(@"kInfoConfirmClearHistory", @"")

#define kHistoryCellHeight					35
#define kHistoryButtonHeight				40
#define kHistoryTablePadding				30
#define kHistoryTableBottomPadding			0

#define kHistoryButtonTableLongestPadding	30
#define kHistoryButtonTableNormalPadding	15
#define kHistoryButtonTableNoRecordPadding	35

@interface UISearchHistoryItem : NSObject
{
	NSString* name;
}

@property (nonatomic, retain) NSString* name;

- (id)initWithName:(NSString*)name;

@end

enum SearchHistorySection {
	kSearchHistorySectionText,
	kSearchHistorySectionNum,
	kSearchHistorySectionClear
	
};

@protocol UISearchHistoryViewDelegate;

@interface UISearchHistoryView : UIView <UITableViewDelegate, UITableViewDataSource> {

	UIButton*			clearHistoryButton;
	UIButton*			backButton;
	UITableView*		tbView;
	
	NSMutableArray*	searchHistoryList;
	
	NSObject<UISearchHistoryViewDelegate>	*delegate;
	
} 

@property (nonatomic, retain) UITableView* tbView;
@property (nonatomic, retain) NSMutableArray*	searchHistoryList;
@property (nonatomic, retain) NSObject<UISearchHistoryViewDelegate>	*delegate;
@property (nonatomic, retain) UIButton*			clearHistoryButton;
@property (nonatomic, retain) UIButton*			backButton;

- (void)createButton;
- (void)updateButtonFrame;
- (void)updateView;
- (int)getButtonTop;
 
- (id)initWithFrame:(CGRect)frame historyList:(NSMutableArray*)historyList;

@end

@protocol UISearchHistoryViewDelegate

- (void)didSelectItem:(NSString*)item atIndex:(int)index;

- (void)didClearAllItem;

- (void)didClickBack;

- (void)didDeleteItem:(NSString*)item atIndex:(int)index;

@end

