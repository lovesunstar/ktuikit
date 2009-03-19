//
//  KTTabViewController.h
//  KTUIKit
//
//  Created by Cathy on 18/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTViewController.h"

@class KTView;
@class KTTabItem;

@interface KTTabViewController : KTViewController 
{
	@private
	KTView *				wContentView;
	KTView *				wTabView;
	NSInteger				mSelectedTabIndex;
	id						wDelegate;
	NSMutableArray *		mTabItems;
	
	NSArrayController *		mTabItemArrayController;
}

@property (readwrite, assign) NSInteger selectedTabIndex;
@property (readwrite, assign) id delegate;
@property (readonly) NSArrayController *	tabItemArrayController;

// adding/removing tabs

- (void)addTabItem:(KTTabItem*)theTabItem;
- (void)removeTabItem:(KTTabItem*)theTabItem;
- (void)insertTabItem:(KTTabItem*)theTabItem atIndex:(NSInteger)theIndex;



- (void)addTabAtIndex:(NSInteger)theTabIndex forViewController:(KTViewController*)theViewController;
- (void)addTabForViewController:(KTViewController*)theViewController;
- (void)removeTabForViewController:(KTViewController*)theViewController;
- (void)removeTabAtIndex:(NSInteger)theTabIndex;
- (NSInteger)numberOfTabs;
- (NSArray*)viewControllers;
- (NSArray*)tabItems;

// selection

- (KTTabItem*)selectedTabItem;

- (IBAction)selectTab:(id)theSender;
- (void)selectTabAtIndex:(NSInteger)theTabIndex;
- (void)selectTabForViewController:(KTViewController*)theViewController;


@end
