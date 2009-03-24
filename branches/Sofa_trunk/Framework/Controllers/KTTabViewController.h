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
	NSArrayController *		mTabItemArrayController;
	KTTabItem *				mCurrentSelectedTab;
	BOOL					mReleaseViewControllersWhenNotSeletcted;
	id						wDelegate;
}

@property (readonly) NSArrayController * tabItemArrayController;
@property (readwrite, assign) BOOL releaseViewControllersWhenNotSeletcted;
@property (readwrite, assign) id delegate;

// adding/removing tabs
- (void)addTabItem:(KTTabItem*)theTabItem;
- (void)removeTabItem:(KTTabItem*)theTabItem;
- (void)insertTabItem:(KTTabItem*)theTabItem atIndex:(NSInteger)theIndex;
- (NSArray*)tabItems;

// selection
- (KTTabItem*)selectedTabItem;
- (IBAction)selectTab:(id)theSender;
- (void)selectTabAtIndex:(NSInteger)theTabIndex;
- (void)selectTabItem:(KTTabItem*)theTabItem;

@end